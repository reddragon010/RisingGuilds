class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.validates_length_of_password_field_options = {:on => :update, :minimum => 4, :if => :has_no_credentials?}
  end
  
  is_gravtastic!
  
  has_many :characters, :dependent => :nullify
  has_many :assignments, :dependent => :destroy
  has_many :roles, :through => :assignments
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
  
  def guild_role_id(guild_id)
    a = self.assignments.where(:guild_id => guild_id).order("role_id").last
    unless a.nil?
      return a.role_id
    else
      return false
    end
  end
  
  def kickable_by?(user, guild)
    user == self || user.guild_role_id(guild.id) < self.guild_role_id(guild.id)
  end
  
  def promoteable_by?(user, guild)
    user.guild_role_id(guild.id) < self.guild_role_id(guild.id)
  end
  
  def demoteable_by?(user, guild)
    user == self || user.guild_role_id(guild.id) < self.guild_role_id(guild.id)
  end
  
  def role_symbols
    role_symbols = Array.new
    role_symbols << :admin if admin?
    roles.each do |role|
      role_symbols << role.name.underscore.to_sym
    end
    role_symbols << :user
    role_symbols << :member unless guilds.empty?
    return role_symbols
  end
end
