class Character < ActiveRecord::Base
  belongs_to :Guild
  has_many :Events
  has_many :RemoteQueries
  
  
end
