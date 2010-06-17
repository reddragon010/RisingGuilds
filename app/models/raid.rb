class Raid < ActiveRecord::Base
  has_and_belongs_to_many :guilds
  has_many :attendances
  has_many :characters, :through => :attendances
  belongs_to :guild
  
  attr_accessor :invitation_window, :duration, :invited_guild

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
    return 15 if new_record?
    if @invitation_window.nil?
      return Integer((self.start.to_f - self.invite_start.to_f) / 60.to_f)
    else
      return @invitation_window
    end
  end
  
  def duration
    return 1 if new_record?
    if @duration.nil?
      return Integer((self.end - self.start).to_f / 3600.to_f)
    else
      return @duration
    end
  end
  
  def date
    self.start.to_date
  end
  
  def levelrange
    if self.min_lvl.nil? && self.max_lvl.nil?
      return "1 - 80"
    elsif self.max_lvl.nil?
      return self.min_lvl.to_s + " - 80"
    elsif self.min_lvl.nil?
      return "1 - " + self.max_lvl.to_s
    else
      return self.min_lvl.to_s + " - " + self.max_lvl.to_s
    end
  end
  
  def closed?
    return false if self.new_record?
    self[:closed] || self.invite_start < Time.now
  end
  
end
