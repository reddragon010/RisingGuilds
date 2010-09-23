class Guild < ActiveRecord::Base
  has_many :events, :dependent => :destroy
  has_many :characters, :dependent => :nullify
  has_many :remoteQueries, :dependent => :destroy
  has_many :assignments, :dependent => :destroy
  has_many :users, :through => :assignments
  has_and_belongs_to_many :raids
  has_many :newsentries
  
  before_validation(:on => :create) do
    self.token = ActiveSupport::SecureRandom::hex(8) if self.new_record? and self.token.nil?
  end
  
  validates_presence_of :name
  validates_length_of :description, :minimum => 100, :message => "please write some more words"
  validates_length_of :description, :maximum => 1000, :message => "ok thats to much. Please keep a little bit shorter"
  validates_uniqueness_of :name
  
  validates_presence_of :token
  validates_uniqueness_of :token
  
  validates_presence_of :realm
  
  has_attached_file :logo, :default_url => "defaults/:attachment/:style/missing.png", :default_style => :formatted, :styles => { :formatted => {
                                          :geometry => '100x100#',
                                          :quality => 80,
                                          :format => 'PNG'
                                          }}
  
    
  
  attr_accessor :serial
  
  def leaders
    @leaders = Array.new
    @leaders_role_id ||= Role.where(:name => "leader").id
    assignments.where(:role_id => @leaders_role_id).each{|a| @leaders << a.user}
    @leaders
  end
  
  def officers
    @officers = Array.new
    @officers_role_id ||= Role.where(:name => "officer").id
    assignments.where(:role_id => @officers_role_id).each{|a| @officers << a.user}
    @officers
  end
  
  def raidleaders
    @raidleaders = Array.new
    @raidleaders_role_id ||= Role.where(:name => "raidleader").id
    assignments.where(:role_id => @raidleaders_role_id).each{|a| @raidleaders << a.user}
    @raidleaders
  end
  
  def members
    @members = Array.new
    @members_role_id ||= Role.where(:name => "member").id
    assignments.where(:role_id => @members_role_id).each{|a| @members << a.user}
    @members
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
  
  protected
  
  
  def validate
    errors.add_to_base "incorrect serial!" unless Digest::SHA1.hexdigest("#{self.name}:#{configatron.guilds.serial_salt}") == self.serial || configatron.arsenal.test == true
  end
  
  def before_destroy
    Raid.where(:guild_id => self.id).each(&:destroy)
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
