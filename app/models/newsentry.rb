class Newsentry < ActiveRecord::Base
  belongs_to :guild
  belongs_to :user
  
  def is_public?
    self.public
  end
  
  def is_sticky?
    self.sticky
  end
end
