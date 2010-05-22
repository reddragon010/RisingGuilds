class Raid < ActiveRecord::Base
  belongs_to :guild
  has_many :characters, :through => :attendances
  
end
