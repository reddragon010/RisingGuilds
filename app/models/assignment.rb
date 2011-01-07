class Assignment < ActiveRecord::Base
  belongs_to :user
  belongs_to :guild
end
