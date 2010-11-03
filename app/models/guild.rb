class Guild < ActiveRecord::Base
  has_many :events, :dependent => :destroy
  has_many :characters, :dependent => :nullify
  has_many :assignments, :dependent => :destroy
  has_many :users, :through => :assignments
  has_and_belongs_to_many :raids
  has_many :newsentries
  
  before_validation(:on => :create) do
    self.token = ActiveSupport::SecureRandom::hex(8) if self.new_record? and self.token.nil?
  end
  
  before_destroy do
    Raid.where(:guild_id => self.id).each(&:destroy)
  end
  
  validates_presence_of :name
  validates_presence_of :description
  validates_uniqueness_of :name
  
  validates_presence_of :token
  validates_uniqueness_of :token
  
  validates_presence_of :realm
  
  validate :serial_check, :on => :create
  
  has_attached_file :logo, :default_url => "defaults/:attachment/:style/missing.png", :default_style => :formatted, :styles => { :formatted => {
                                          :geometry => '100x100#',
                                          :quality => 80,
                                          :format => 'PNG'
                                          }}
  
    
  
  attr_accessor :serial
  
  def leaders
    @leaders = Array.new
    @leaders_role_id ||= Role.where(:name => "leader").first.id
    assignments.where(:role_id => @leaders_role_id).each{|a| @leaders << a.user}
    @leaders
  end
  
  def officers
    @officers = Array.new
    @officers_role_id ||= Role.where(:name => "officer").first.id
    assignments.where(:role_id => @officers_role_id).each{|a| @officers << a.user}
    @officers
  end
  
  def raidleaders
    @raidleaders = Array.new
    @raidleaders_role_id ||= Role.where(:name => "raidleader").first.id
    assignments.where(:role_id => @raidleaders_role_id).each{|a| @raidleaders << a.user}
    @raidleaders
  end
  
  def members
    @members = Array.new
    @members_role_id ||= Role.where(:name => "member").first.id
    assignments.where(:role_id => @members_role_id).each{|a| @members << a.user}
    @members
  end
  
  def managers
    self.officers + self.leaders
  end
  
  def reset_token
    self.token = ActiveSupport::SecureRandom::hex(8)
    self.save
  end
  
  def valid_name?
    url = configatron.arsenal.url.base 
    url += configatron.arsenal.url.guild.info 
    if configatron.arsenal.test.nil?
      url += '?' + configatron.arsenal.url.realm 
      url += self.realm + "&"
      url += configatron.arsenal.url.guild.name
      url += CGI.escape(self.name)
    else
      return true #just mock it for tests
    end
    
    begin # check header response
      res = Net::HTTP.get_response(URI.parse(url))
      case res
        when Net::HTTPSuccess then
          begin
            check_xml(res.body)
            return true
          rescue
            return false
          end
        when Net::HTTPClientError then 
          raise "ClientError on #{url}"
        else raise "ServerError on #{url}"
      end
    rescue # Recover on DNS failures..
      raise "DNS failure on #{url}"
    end
  end
  
  def verified?
    self.verified
  end
  
  def ail
    ails = self.characters.where(:level => 80).collect{|char| char.ail}
    size = ails.size
    ails.delete_if{|x| x.nil?}
    unless ails.empty?
      return ails.sum / size
    else
      return nil
    end
  end
    
  def activity
    activities = self.characters.where(:level => 80,:main => true).collect{|char| char.netto_activity}
    activities.delete_if{|x| x.nil?}
    unless activities.empty?
      return activities.sum / activities.size
    else
      return nil
    end
  end
  
  def mainratio
    return nil if self.characters.empty?
    unless self.characters.where(:main => true).nil? || self.characters.where(:main => false).nil?
      mains = self.characters.where(:main => true).count 
      alts = self.characters.where(:main => false).count
      return Integer(mains.to_f / alts.to_f * 100)
    else
      return nil
    end
  end
  
  def classratio
    return nil if self.characters.empty?
    members = self.characters.count
    sum = 0
    (1..9).each do |i|
      sum += (((self.characters.where(:class_id => i, :level => 80).count.to_f / members.to_f) - (1.to_f/9.to_f))*100).abs
    end
    return Integer(sum)
  end
  
  def growth
    return nil if self.characters.empty?
    members = self.characters.count
    joined = Event.where("guild_id = ? AND action = ? AND created_at > ?",self.id ,"joined",1.month.ago).count
    left = Event.where("guild_id = ? AND action = ? AND created_at > ?",self.id,"left",1.month.ago).count
    growth = joined - left
    unless (members - growth) == 0
      return Integer((growth.to_f / (members-growth).to_f)*100)
    else
      return nil
    end
  end
  
  def achivementpoints
    achivementpoints = self.characters.where(:level => 80).collect{|char| char.achivementpoints}
    achivementpoints.delete_if{|x| x.nil?}
    unless achivementpoints.empty?
      return Integer(achivementpoints.sum / achivementpoints.size)
    else
      return nil
    end
  end
  
  def sync
    xml = Arsenal::get_guild_xml(self) 
    
    faction = (xml%'guildInfo'%'guildHeader')[:faction].to_i
    self.update_attribute(:faction_id,faction) if self.faction_id.nil?
    
    if !(xml%'guildInfo').children.empty?
			arsenal_chars = Array.new
			arsenal_char_names = Array.new
			arsenal_char_ranks = Hash.new
			
			(xml%'guildInfo'%'guild'%'members'/:character).each do |char|
			    arsenal_char_names << char[:name]
			    arsenal_char_ranks[char[:name]] = char[:rank].to_i
					arsenal_chars << Character.new(:name => char[:name], :guild_id => self.id, :class_id => char[:classId],:gender_id => char[:genderId],:race_id => char[:raceId], :level => char[:level],:rank => char[:rank], :faction_id => faction, :realm => self.realm)
			end
			db_char_names = self.characters.collect {|c| c.name}
			
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
              event.guild = self
              event.content = self.name
              event.character = char
              event.save
            end
          end
        end
      end

      #Delete missing chars
      unless missing_char_names.empty?
        self.characters.each do |char|
          if missing_char_names.include?(char.name) then
            event = Event.new(:action => 'left')
            event.character = char
            event.guild = self
            event.content = self.name
            event.save
            attributes = {:guild_id => nil, :rank => nil}
            char.update_attributes(attributes)
          end
        end
      end
      
      #rank update
      unless db_char_names.empty?
        self.characters.each do |char|
          if char.rank != arsenal_char_ranks[char.name]
            content = char.rank
            char.rank = arsenal_char_ranks[char.name]
            if char.rank < arsenal_char_ranks[char.name]
               event = Event.new(:action => 'promoted')
               event.character = char
               event.guild = self
               event.content = content
               event.save
            elsif char.rank < arsenal_char_ranks[char.name]
              event = Event.new(:action => 'demoted')
              event.character = char
              event.guild = self
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
  
  protected
  
  
  def serial_check
    errors.add_to_base "incorrect serial!" unless Digest::SHA1.hexdigest("#{self.name}:#{configatron.guilds.serial_salt}") == self.serial || configatron.arsenal.test == true
  end
  
  #get the preprocessed XML-Code from URI
  def check_xml(html)
    doc = Hpricot.XML(html)
  	errors = doc.search("*[@errCode]")
  	if errors.size > 0
  		errors.each do |error|
  			raise error[:errCode]
  		end
  	elsif (doc%'page').nil?
  		raise "EmptyPage (#{url})"
  	else
  		return true
  	end
  end
end
