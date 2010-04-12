class Guild < ActiveRecord::Base
  has_many :events
  has_many :characters
  has_many :remoteQueries
  has_many :assignments
  has_many :users, :through => :assignments
  
  named_scope :managers, :conditions => {}
  
  validates_presence_of :name
  validates_length_of :description, :minimum => 100, :message => "please write some more words"
  validates_length_of :description, :maximum => 1000, :message => "ok thats to much. Please keep a little bit shorter"
  
  validates_presence_of :token
  validates_uniqueness_of :token
  
  def managers
    @managers = Array.new
    assignments.find_all_by_role_id(1).each{|a| @managers << a.user}
    @managers
  end
  
  def update_guild
    Guild.RemoteQueries << RemoteQuery.new(:priority => 1, :efford => 5, :action =>"update_guild")
  end
  
  protected
  def before_validation_on_create
    self.token = ActiveSupport::SecureRandom::hex(8) if self.new_record? and self.token.nil?
  end
end
