class Event < ActiveRecord::Base
  belongs_to :Character
  belongs_to :Guild
end
