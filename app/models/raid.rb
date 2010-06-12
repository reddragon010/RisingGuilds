class Raid < ActiveRecord::Base
  belongs_to :guild
  has_many :attendances
  has_many :characters, :through => :attendances
  
  attr_accessor :invitation_window, :duration

  #only future Date/Time is valid
  validates_each(:invite_start,:start,:end) do |record, attr, value|
    record.errors.add attr, 'have to be in the future' if value < Time.now
  end

  validates_each(:invite_start) do |record, attr, value|
    record.errors.add attr, 'have to happen befor start' if value > record.start
  end
  
  validates_each(:end) do |record, attr, value|
    record.errors.add attr, 'have to happen after start' if value < record.start
  end

  def invitation_window
    if start.nil? || invite_start.nil?
      return @invitation_window
    else
      return Integer((self.start.to_f - self.invite_start.to_f) / 60.to_f)
    end
  end
  
  def duration
    if self.start.nil? || self.end.nil?
      return @duration
    else
      return Integer((self.end - self.start).to_f / 3600.to_f)
    end
  end

  def date
    self.start.to_date
  end
  
  def closed?
    return false if self.new_record?
    self[:closed] || self.invite_start < Time.now
  end
  
end
