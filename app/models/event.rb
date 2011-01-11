class Event < ActiveRecord::Base
  include ActionView::Helpers::DateHelper
  
  belongs_to :character
  belongs_to :guild
  
  cattr_reader :per_page
  @@per_page = 10
  
  scope :visible, where(:visible => true)
  
  def character_name
    unless self.character.blank?
      self.character.name
    else
      nil
    end
  end
  
  def created_ago
    time_ago_in_words(self.created_at)
  end
end
