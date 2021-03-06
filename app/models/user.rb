class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.validates_length_of_password_field_options = {:on => :update, :minimum => 4, :if => :has_no_credentials?}
  end
  include Gravtastic
  is_gravtastic
  
  has_many :characters, :dependent => :nullify
  has_many :assignments, :dependent => :destroy
  has_many :guilds, :through => :assignments
  has_many :newsentries, :dependent => :nullify
  
  attr_accessible :login, :language, :email, :icq, :jabber, :msn, :skype, :signature, :password, :password_confirmation
  
  
  
  # we need to make sure that either a password or openid gets set
  # when the user activates his account
  def has_no_credentials?
    self.crypted_password.blank?
  end
  
  # now let's define a couple of methods in the user model. The first
  # will take care of setting any data that you want to happen at signup
  # (aka before activation)
  def signup!(params)
    self.login = params[:user][:login]
    self.email = params[:user][:email]
    save_without_session_maintenance
  end
  
  # the second will take care of setting any data that you want to happen
  # at activation. at the very least this will be setting active to true
  # and setting a pass, openid, or both.
  def activate!(params)
    self.active = true
    self.password = params[:user][:password]
    self.password_confirmation = params[:user][:password_confirmation]
    save
  end  
  
  def active?
    self.active
  end
  
  def guild_role_level(guild_id)
    levels = configatron.guilds.roles
    assignments = self.assignments.where(:guild_id => guild_id).all
    unless assignments.blank?
      return assignments.map{|a| levels.index(a.role.downcase)}.sort.last
    else
      return -1
    end
  end
  
  def kickable_by?(user, guild)
    (user == self && (!guild.leaders.include?(user) || guild.leaders.count > 1)) || user.guild_role_level(guild.id) > self.guild_role_level(guild.id)
  end
  
  def promoteable_by?(user, guild)
    user.guild_role_level(guild.id) > self.guild_role_level(guild.id) && self.guild_role_level(guild.id) != 3
  end
  
  def demoteable_by?(user, guild)
    ((user == self && (!guild.leaders.include?(user) || guild.leaders.count > 1))  || user.guild_role_level(guild.id) > self.guild_role_level(guild.id)) && self.guild_role_level(guild.id) != 0
  end
  
  def roles
    self.assignments.all.map{|a| a.role}
  end
  
  def role_symbols
    role_symbols = Array.new
    role_symbols << :admin if admin?
    roles.each do |role|
      role_symbols << role.downcase.underscore.to_sym
    end
    role_symbols << :user
    role_symbols << :member unless guilds.empty?
    return role_symbols.uniq
  end
end
