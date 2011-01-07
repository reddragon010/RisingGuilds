class Attendance < ActiveRecord::Base
  belongs_to :raid
  belongs_to :character
  has_one :guild, :through => :raid
  
  validates_presence_of :raid_id
  validates_presence_of :character_id
  validates_presence_of :status
  
  #validate :max_attendances
  
  protected
  
  def max_attendances
    errors.add_to_base "Max attendances are reached! Sorry" unless self.raid.attendances.count < self.raid.max_attendances
  end
end
