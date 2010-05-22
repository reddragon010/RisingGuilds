class Guild < ActiveRecord::Base
  has_many :events
  has_many :characters
  has_many :remoteQueries
  has_many :assignments
  has_many :users, :through => :assignments
  
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
  
  def managers
    @managers = Array.new
    @managers_role_id ||= Role.find_by_name("guildmanager").id
    assignments.find_all_by_role_id(@managers_role_id).each{|a| @managers << a.user}
    @managers
  end
  
  def leaders
    @leaders = Array.new
    @leaders_role_id ||= Role.find_by_name("guildleader").id
    assignments.find_all_by_role_id(@leaders_role_id).each{|a| @leaders << a.user}
    @leaders
  end
  
  def officers
    @officers = Array.new
    @officers_role_id ||= Role.find_by_name("guildofficer").id
    assignments.find_all_by_role_id(@officers_role_id).each{|a| @officers << a.user}
    @officers
  end
  
  def members
    @members = Array.new
    @members_role_id ||= Role.find_by_name("guildmember").id
    assignments.find_all_by_role_id(@members_role_id).each{|a| @members << a.user}
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
      return true
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
  
  protected
  def before_validation_on_create
    self.token = ActiveSupport::SecureRandom::hex(8) if self.new_record? and self.token.nil?
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
