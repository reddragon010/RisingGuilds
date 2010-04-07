require "open-uri"
require "hpricot"
require 'net/http'
require 'uri'

class RemoteQuery < ActiveRecord::Base
  belongs_to :guild
  belongs_to :character
  
  validates_presence_of :priority
  validates_presence_of :efford
  validates_presence_of :action
  
  def execute(attribute=nil)
    begin
      self.send(self.action,attribute)
    rescue => exception
      raise "#{exception.to_s} on executing RemoteQuery #{self.id} \n #{exception.backtrace.join("\n")}"
    else
      self.destroy
      return true
    end
  end
  
  #private
  
  def update_guild(url)
    url = "http://arsenal.rising-gods.de/guild-info.xml?r=PvE-Realm&gn=#{self.guild.name}" if url.nil?
    xml = get_xml(url) 
    
    if !(xml%'guildInfo').children.empty?
			arsenal_chars = Array.new
			arsenal_char_names = Array.new
			
			(xml%'guildInfo'%'guild'%'members'/:character).each do |char|
			    arsenal_char_names << char[:name]
					arsenal_chars << Character.new(:name => char[:name], :guild_id => self.guild.id, :class_id => char[:classId],:gender_id => char[:genderId],:race_id => char[:raceId], :level => char[:level],:rank => char[:rank])
			end
			db_char_names = self.guild.characters.collect {|c| c.name}
			
			# Calculate new/missing chars
      missing_char_names = db_char_names - arsenal_char_names
      new_char_names = arsenal_char_names - db_char_names

      # Add new chars
      unless new_char_names.empty?
        arsenal_chars.each do |char|
          if new_char_names.include?(char.name) then
            event = Event.new(:action => 'joined')
            event.guild = self.guild
            
            exist_char = Character.find_all_by_name(char.name)
            unless exist_char.empty?
              char = exist_char.first
              char.update_attribute(:guild_id,id)
            end
            
            event.character = char
            event.save
          end
        end
      end

      #Delete missing chars
      unless missing_char_names.empty?
        characters.each do |char|
          if missing_char_names.include?(char.name) then
            event = Event.new(:action => 'left')
            event.character = char
            event.guild = self.guild
            event.save
            char.update_attribute(:guild_id, nil)
          end
        end
      end
      return true
    else
      raise "Empty Guild-Info"
    end
  end
  
  def update_guild_onlinelist(url)
    url = "http://www.rising-gods.de/components/com_onlinelist/views/onlinelist/ajax_request.php?server=pve" if url.nil?
    doc = get_html(url)
    
    #process every member of the guild
    self.guild.characters.each do |char|
      #test if char is online
      newonline = doc.include?(">#{char.name}<")
      attributes = Hash.new
      #if char stay online
      if char.online == true && newonline == true then
        #workaround: default activity is nil not 0
        char.activity = 0 if char.activity.nil?
        #If user was still a hour online adds 1 to activity
        attributes[:activity] = char.activity + 1 unless (char.last_seen + 1.hour) >= Time.now 
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
=begin
  def update_character(url)
    url = "http://arsenal.rising-gods.de/character-sheet.xml?r=PvE-Realm&cn=#{self.guild.name}" if url.nil?
    xml = get_xml(url) 
    
    attributes = Hash.new
    attributes['level'] = xml[:level]
    attributes['classid'] = xml[:classId]
    attributes['raceid'] = xml.race_id
    attributes['factionid'] = arsenal_char.faction_id
    attributes['genderid'] = arsenal_char.gender_id
    attributes['points'] = arsenal_char.points
    
    unless arsenal_char.talent_spec.nil? || arsenal_char.talent_spec.empty?
      arsenal_char.talent_spec.each_with_index do |talentspec,i|
        attributes["talentspec#{i+1}"] = talentspec
      end
    end

    unless arsenal_char.professions.nil? || arsenal_char.professions.empty?
      arsenal_char.professions.each_with_index do |profession,i|
        attributes["profession#{i+1}"] = profession
      end
    end
    
    attributes['icon'] = arsenal_char.icon
    attributes['race_icon'] = arsenal_char.race_icon
    attributes['class_icon'] = arsenal_char.class_icon

    self.update_attributes(attributes)
  end
=end
  
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
				response = case res
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
    response = get_html(url)
    
    doc = Hpricot.XML(response)
		errors = doc.search("*[@errCode]")
		if errors.size > 0
			errors.each do |error|
				raise error[:errCode]
			end
		elsif (doc%'page').nil?
			raise "EmptyPage"
		else
			return (doc%'page')
		end
	end
end
