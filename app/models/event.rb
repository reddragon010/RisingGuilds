class Event < ActiveRecord::Base
  belongs_to :character
  belongs_to :guild
  
  cattr_reader :per_page
  @@per_page = 10
end
