class RemoteQuery < ActiveRecord::Base
  belongs_to :guild
  belongs_to :character
end
