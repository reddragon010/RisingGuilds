class Attendance < ActiveRecord::Base
  belongs_to :raid
  belongs_to :character
  has_one :guild, :through => :raid
end
