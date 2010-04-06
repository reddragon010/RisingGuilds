class Character < ActiveRecord::Base
  belongs_to :guild
  has_many :events
  has_many :remoteQueries
  
  
end
