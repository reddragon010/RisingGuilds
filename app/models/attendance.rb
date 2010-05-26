class Attendance < ActiveRecord::Base
  belongs_to :raid
  belongs_to :character
  has_one :guild, :through => :raid
  
  validates_presence_of :raid_id
  
  protected
  
  def validate
    #errors.add_to_base "Max attendances are reached! Sorry" unless self.raid.attendances.count < self.raid.max_attendances
  end
end
