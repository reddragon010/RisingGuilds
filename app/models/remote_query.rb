class RemoteQuery < ActiveRecord::Base
  belongs_to :guild
  belongs_to :character
  
  validates_presence_of :priority
  validates_presence_of :efford
  validates_presence_of :action
  
  def execute
    self.send(self.action)
  end
  
  def update_guild
    "update_guild"
  end
end
