class Assignment < ActiveRecord::Base
  belongs_to :guild
  belongs_to :character
  belongs_to :role
end
