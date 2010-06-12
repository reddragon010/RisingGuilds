class Raid < ActiveRecord::Base
  belongs_to :guild
  has_many :attendances
  has_many :characters, :through => :attendances
  
  attr_accessor :invitation_window, :duration

#only future Date/Time is valid
# Bug with new date collum
#  validates_each(:date) do |record, attr, value|
#    record.errors.add attr, 'have to be in the future' if value < Date.today
#  end

  
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

=begin
  def invitation_window=(minutes)
    self.invite_start = self.start - minutes.to_i.minutes
  end
  
  def invitation_window
    if self.start.nil? || self.invite_start.nil?
      return 30
    else
      return Integer((self.start - self.invite_start).to_f / 60.to_f)
    end
  end

  def duration=(hours)
    self.end = self.start + hours.to_i.hours
  end
  
  def duration
    if self.start.nil? || self.end.nil?
      return 2
    else
      return Integer((self.end - self.start).to_f / 3600.to_f)
    end
  end
=end
  
  def date
    self.start.to_date
  end
  
  def closed?
    return false if self.new_record?
    self[:closed] || self.invite_start < Time.now
  end
  
end
