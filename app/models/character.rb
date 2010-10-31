class Character < ActiveRecord::Base
  belongs_to :guild
  has_many :events
  belongs_to :user
  has_many :attendances
  
  serialize :profession1, Arsenal::Profession
  serialize :profession2, Arsenal::Profession
  serialize :talentspec1, Arsenal::TalentSpec
  serialize :talentspec2, Arsenal::TalentSpec
  serialize :items
  
  validates_uniqueness_of :name
  validates_presence_of :realm
  
  scope :are_online, where(:online => true)
  scope :online_today, where("last_seen >= ?", Time.now.midnight)
  
  def netto_activity
    Integer((self.activity / ((Time.now - self.created_at) / 60 / 60)) * 100) unless self.activity.nil?
  end
  
  def sync
    xml = Arsenal::get_character_xml(self)
    
    attributes = Hash.new
    attributes['level']             = (xml%'characterInfo'%'character')[:level]
    attributes['achivementpoints']  = (xml%'characterInfo'%'character')[:points]
    
    (xml%'professions'/:skill).each_with_index do |skill,i|
		  attributes["profession#{i+1}"] = Arsenal::Profession.new(skill)
		end
		
		unless (xml%'talentSpecs').nil?
      (xml%'talentSpecs'/:talentSpec).each_with_index do |talentSpec,i|
        attributes["talentspec#{i+1}"] = Arsenal::TalentSpec.new(talentSpec)
      end
    end
    
    items = Array.new
    (xml%'items'/:item).each do |item|
			items << Arsenal::Item.new(item)
		end
		attributes["items"] = items unless items.empty?
    
    Event.create(:character_id => self.id, :action => "levelup", :content => attributes['level']) if !self.level.nil? && attributes['level'].to_i != self.level.to_i
    
    self.update_attributes(attributes)
  end
  
  def sync_ail
    return true if self.items.nil?
    
    ilevelsum = 0
    items = Array.new
    self.items.each do |item|
      xml = Arsenal::get_item_xml(item)
      item.get_info(xml)
      ilevelsum += item.level
      items << item
    end
    
    ail = Integer(ilevelsum / self.items.count)
    ailstddev = ail_stddev(items)
    
    attributes = {:ail => ail, :ailstddev => ailstddev, :items => items}
    self.update_attributes(attributes)
  end
	
	def ail_stddev(items)
    values = items.collect{|i| i.level}
    return false if values.include?(nil)
    average = values.inject(:+).to_f / values.size
    result = 0
    result.to_f
    values.each{|value| result += ((value-average)**2) * (1 / values.size.to_f)}
    return Integer(Math.sqrt(result))
  end
end