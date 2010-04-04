class Guild < ActiveRecord::Base
  has_many :Events
  has_many :Characters
end
