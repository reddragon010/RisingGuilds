class Assignment < ActiveRecord::Base
  belongs_to :user
  belongs_to :guild
  belongs_to :role
  
  validates_presence_of :guild_id, :message => "can't be blank"
end
