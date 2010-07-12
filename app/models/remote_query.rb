class RemoteQuery < ActiveRecord::Base
  belongs_to :guild
  belongs_to :character
  
  validates_presence_of :priority
  validates_presence_of :efford
  validates_presence_of :action
  
  def execute
    begin
      self.send(self.action)
    rescue => exception
      raise "#{exception.to_s} on executing RemoteQuery #{self.id} \n #{self.attributes.to_yaml} \n #{exception.backtrace.join("\n")}"
      logger.error "#{exception.to_s} on executing RemoteQuery #{self.id} \n #{self.attributes.to_yaml} \n #{exception.backtrace.join("\n")}"
    else
      return true
    ensure
      self.destroy
    end
  end
  
  
  
  private
  
  def update_guild
    raise "missing guild" if self.guild.nil?
    
    # http://arsenal.rising-gods.de/ guild-info.xml ? r= #{self.guild.realm} gn= #{CGI.escape(self.guild.name)}
    url = configatron.arsenal.url.base 
    url += configatron.arsenal.url.guild.info 
    if configatron.arsenal.test.nil?
      url += '?' + configatron.arsenal.url.realm 
      url += self.guild.realm + "&"
      url += configatron.arsenal.url.guild.name
      url += CGI.escape(self.guild.name)
    end

    
    xml = get_xml(url) 
    
    faction = (xml%'guildInfo'%'guildHeader')[:faction].to_i
    
    if !(xml%'guildInfo').children.empty?
			arsenal_chars = Array.new
			arsenal_char_names = Array.new
			arsenal_char_ranks = Hash.new
			
			(xml%'guildInfo'%'guild'%'members'/:character).each do |char|
			    arsenal_char_names << char[:name]
			    arsenal_char_ranks[char[:name]] = char[:rank].to_i
					arsenal_chars << Character.new(:name => char[:name], :guild_id => self.guild.id, :class_id => char[:classId],:gender_id => char[:genderId],:race_id => char[:raceId], :level => char[:level],:rank => char[:rank], :faction_id => faction, :realm => self.guild.realm)
			end
			db_char_names = self.guild.characters.collect {|c| c.name}
			
			# Calculate new/missing chars
      missing_char_names = db_char_names - arsenal_char_names
      new_char_names = arsenal_char_names - db_char_names

      # Add new chars
      unless new_char_names.empty?
        arsenal_chars.each do |char|
          if new_char_names.include?(char.name) then
            #Move an existing char instead of creating a new one
            exist_char = Character.find_by_name(char.name)
            unless exist_char.nil?
              exist_char.rank = char.rank
              exist_char.guild = char.guild
              char = exist_char
            end
            
            #save it
            char.save!
            
            #Trigger Join-Event
            unless db_char_names.empty?
              event = Event.new(:action => 'joined')
              event.guild = self.guild
              event.character = char
              event.save
            end
          end
        end
      end

      #Delete missing chars
      unless missing_char_names.empty?
        self.guild.characters.each do |char|
          if missing_char_names.include?(char.name) then
            event = Event.new(:action => 'left')
            event.character = char
            event.guild = self.guild
            event.save
            attributes = {:guild_id => nil, :rank => nil}
            char.update_attributes(attributes)
          end
        end
      end
      
      #rank update
      unless db_char_names.empty?
        self.guild.characters.each do |char|
          if char.rank != arsenal_char_ranks[char.name]
            content = char.rank
            char.rank = arsenal_char_ranks[char.name]
            if char.rank < arsenal_char_ranks[char.name]
               event = Event.new(:action => 'promoted')
               event.character = char
               event.guild = self.guild
               event.content = content
               event.save
            elsif char.rank < arsenal_char_ranks[char.name]
              event = Event.new(:action => 'demoted')
              event.character = char
              event.guild = self.guild
              event.content = content
              event.save
            end
            char.save!
          end
        end
      end
      
      return true
    else
      raise "Empty Guild-Info"
    end
  end
  
  def update_guild_rating
    unless self.guild.ail.nil? || self.guild.activity.nil? || self.guild.growth.nil? || self.guild.altratio.nil? || self.guild.classratio.nil? || self.guild.achivementpoints.nil?
      ail = self.guild.ail.to_f / 284.to_f #percentage to maximal itemlevel
      aap = self.guild.achivementpoints.to_f / 10000.to_f #percentage to a high number
      rating = Integer(((ail + aap + self.guild.activity + self.guild.growth + self.guild.mainratio + self.guild.classratio).to_f / 6.to_f)*100)
      self.guild.update_attribute(:rating,rating)
    else
      self.guild.update_attribute(:rating,nil)
    end
  end
  
  def update_guild_onlinelist
    raise "missing guild" if self.guild.nil?
    
    list_realm = self.guild.realm[0..2].downcase
    
    url = configatron.onlinelist.url
    url += list_realm.to_s if configatron.arsenal.test.nil?
    
    doc = get_html(url)
    
    #process every member of the guild
    self.guild.characters.each do |char|
      char.online = false if char.online.nil?
      #test if char is online
      newonline = doc.include?(">#{char.name}<")
      attributes = Hash.new
      #if char stay online
      if char.online == true && newonline == true then
        #If user was online in the last 12 hour => adds 1 to activity
        attributes[:activity] = char.activity + 1 unless (char.last_seen + 12.hour) >= Time.now 
      #if char has been gone offline
      elsif char.online == true && newonline == false then
        attributes[:last_seen] = Time.now
        attributes[:online] = false
      #if char comes online
      elsif char.online == false && newonline == true
        attributes[:last_seen] = Time.now
        attributes[:online] = true
      end
      
      char.update_attributes!(attributes) unless attributes.empty?
    end
    
  end

  def update_character
    raise 'missing character' if self.character.nil?
    
    url = configatron.arsenal.url.base 
    url += configatron.arsenal.url.character.sheet 
    if configatron.arsenal.test.nil?
      url += "?" + configatron.arsenal.url.realm
      url += self.character.realm + "&"
      url += configatron.arsenal.url.character.name
      url += CGI.escape(self.character.name) 
    end
    
    xml = get_xml(url)
    
    attributes = Hash.new
    attributes['level']             = (xml%'characterInfo'%'character')[:level]
    attributes['achivementpoints']  = (xml%'characterInfo'%'character')[:points]
    
    (xml%'professions'/:skill).each_with_index do |skill,i|
		  attributes["profession#{i+1}"] = Character::Profession.new(skill)
		end
		
		unless (xml%'talentSpecs').nil?
      (xml%'talentSpecs'/:talentSpec).each_with_index do |talentSpec,i|
        attributes["talentspec#{i+1}"] = Character::TalentSpec.new(talentSpec)
      end
    end
    
    items = Array.new
    (xml%'items'/:item).each do |item|
			items << Character::Item.new(item)
		end
		attributes["items"] = items unless items.empty?
    
    Event.create(:character_id => self.character.id, :action => "levelup", :content => attributes['level']) if !self.character.level.nil? && attributes['level'].to_i != self.character.level.to_i
    
    self.character.update_attributes(attributes)
  end
  
  def update_character_ail
    #http://eu.wowarmory.com/ item-info.xml ? i=
    url = configatron.wowarmory.url.base
    url += configatron.wowarmory.url.item.info
    url += "?" + configatron.wowarmory.url.item.itemid if configatron.arsenal.test.nil?
    
    return true if self.character.items.nil?
    
    ilevelsum = 0
    items = Array.new
    self.character.items.each do |item|
      xml = get_xml(url + item.id.to_s)
      item.get_info(xml)
      ilevelsum += item.level
      items << item
    end
    
    ail = Integer(ilevelsum / self.character.items.count)
    ailstddev = ail_stddev(items)
    
    attributes = {:ail => ail, :ailstddev => ailstddev, :items => items}
    self.character.update_attributes(attributes)
  end
	
	def ail_stddev(items)
    values = items.collect{|i| i.level}
    return false if values.include?(nil)
    average = values.inject(:+).to_f / values.size
    result = 0
    result.to_f
    values.each{|value| result += ((value-average)**2) * (1 / values.size.to_f)}
    return Integer(Math.sqrt(result))
  end
end

#get the HTML-Code from URI
def get_html(url)
  return open(url).read if !url.include?("http://")
  
  req = Net::HTTP::Get.new(url)
	req["user-agent"] = "Mozilla/5.0 Gecko/20070219 Firefox/2.0.0.2" # ensure returns XML
	
	uri = URI.parse(url)
	
	http = Net::HTTP.new(uri.host, uri.port)
  
	begin
	  http.start do
	    res = http.request req
			# response = res.body
			
			tries = 0
			case res
				when Net::HTTPSuccess, Net::HTTPRedirection
					res.body
				else
					tries += 1
					if tries > 10
						raise 'Timed out'
					else
						retry
					end
				end
	  end
	rescue
		raise 'Specified server at ' + url + ' does not exist.'
	end
end

#get the preprocessed XML-Code from URI
def get_xml(url)
  response = get_html(url) if response.nil?
  
  doc = Hpricot.XML(response)
	errors = doc.search("*[@errCode]")
	if errors.size > 0
		errors.each do |error|
			raise error[:errCode]
		end
	elsif (doc%'page').nil?
		raise "EmptyPage (#{url})"
	else
		return (doc%'page')
	end
end
