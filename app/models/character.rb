class Character < ActiveRecord::Base
  belongs_to :guild, :touch => true
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
  
  def update_onlinestatus
    newonline = ServerStatus.instance(self.realm.to_s).user_online?(self.name.to_s)
    attributes = Hash.new
    
    self.online = false if self.online.nil?
    
    #if char stay online
    if self.online == true && newonline == true then 
      attributes[:last_seen] = Time.now
    #if char has been gone offline
    elsif self.online == true && newonline == false then
      attributes[:last_seen] = Time.now
      attributes[:online] = false
    #if char comes online
    elsif self.online == false && newonline == true
      attributes[:last_seen] = Time.now
      attributes[:online] = true
    end
    self.update_attributes!(attributes) unless attributes.empty?
    self.check_activity unless self.online == false && newonline == false
    return newonline
  end
  
  def check_activity
    if self.last_seen > (Time.now - 3.days)
      self.update_attribute(:activity, self.activity + 1) if (self.activity >= 0 && self.activity < 6)
    else
      self.update_attribute(:activity, self.activity - 1) if (self.activity > 0)
    end
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
		attributes["items"] = items
    
    Event.create(:character_id => self.id, :action => "levelup", :content => attributes['level']) if !self.level.nil? && attributes['level'].to_i != self.level.to_i
    
    self.update_attributes(attributes)
  end
  
  def sync_ail
    return true if self.items.nil? || self.items.count <= 0
    
    ilevelsum = 0
    items = Array.new
    self.items.delete_if{|i| i.slot == 3 || i.slot == 18}.each do |item|
      xml = Arsenal::get_item_xml(item)
      item.level = (xml%'item'%'level').content.to_i
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