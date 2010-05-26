class Raid < ActiveRecord::Base
  belongs_to :guild
  has_many :attendances
  has_many :characters, :through => :attendances
  
  #only future Date/Time is valid
  validates_each(:invite_start,:start,:end) do |record, attr, value|
    record.errors.add attr, 'have to be in the future' if value < Time.now
  end
  
=begin still buggy yet :(
  validates_each(:invite_start) do |record, attr, value|
    record.errors.add attr, 'have to happen befor start' if value > self.start
  end
  
  validates_each(:start) do |record, attr, value|
    record.errors.add attr, 'have to happen after invite start and before end ' if value < self.invite_start && self.end
  end
  
  validates_each(:end) do |record, attr, value|
    record.errors.add attr, 'have to happen after start' if value < self.start
  end
=end
  
  def closed
    return false if self.new_record?
    self[:closed] || self.invite_start < Time.now
  end
  
end
