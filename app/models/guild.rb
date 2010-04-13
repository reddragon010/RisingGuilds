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
  
  def managers
    @managers = Array.new
    assignments.find_all_by_role_id(1).each{|a| @managers << a.user}
    @managers
  end
  
  def leaders
    @managers = Array.new
    assignments.find_all_by_role_id(2).each{|a| @managers << a.user}
    @managers
  end
  
  def officers
    @managers = Array.new
    assignments.find_all_by_role_id(3).each{|a| @managers << a.user}
    @managers
  end
  
  def members
    @members = Array.new
    assignments.find_all_by_role_id(4).each{|a| @members << a.user}
    @members
  end
  
  def reset_token
    self.token = ActiveSupport::SecureRandom::hex(8)
    self.save
  end
  
  protected
  def before_validation_on_create
    self.token = ActiveSupport::SecureRandom::hex(8) if self.new_record? and self.token.nil?
  end
end
