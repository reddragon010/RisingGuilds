class Raid < ActiveRecord::Base
  belongs_to :guild
  has_many :attendances
  has_many :characters, :through => :attendances
  
end
