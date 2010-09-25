class Character < ActiveRecord::Base
  belongs_to :guild
  has_many :events
  has_many :remoteQueries
  belongs_to :user
  has_many :attendances
  
  serialize :profession1, Arsenal::Profession
  serialize :profession2, Arsenal::Profession
  serialize :talentspec1, Arsenal::TalentSpec
  serialize :talentspec2, Arsenal::TalentSpec
  serialize :items
  
  validates_uniqueness_of :name
  validates_presence_of :realm
  
  def netto_activity
    Integer((self.activity / ((Time.now - self.created_at) / 60 / 60)) * 100) unless self.activity.nil?
  end
end