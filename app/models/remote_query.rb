require "open-uri"
require "hpricot"

class RemoteQuery < ActiveRecord::Base
  belongs_to :guild
  belongs_to :character
  
  validates_presence_of :priority
  validates_presence_of :efford
  validates_presence_of :action
  
  def execute(attribute=nil)
    begin
      self.send(self.action,attribute)
    rescue => exception
      raise "#{exception.to_s} on executing RemoteQuery #{self.id} - #{exception.backtrace.join("\n")}"
    else
      self.destroy
      return true
    end
  end
  
  private
  
  def update_guild(uri)
    uri = "http://arsenal.rising-gods.de/guild-info.xml?r=PvE-Realm&gn=#{self.guild.name}" if uri.nil?
    xml = get_xml(uri) 
    
    if !(xml%'guildInfo').children.empty?
      arsenal_char_count = (xml%'guildInfo'%'guild'%'members')[:memberCount].to_i || nil
      
			arsenal_chars = Array.new
			arsenal_char_names = Array.new
			
			(xml%'guildInfo'%'guild'%'members'/:character).each do |char|
			    arsenal_char_names << char[:name]
					arsenal_chars << Character.new(:name => char[:name], :guild_id => self.guild.id, :class_id => char[:classId],:gender_id => char[:genderId],:race_id => char[:raceId], :level => char[:level],:rank => char[:rank])
			end
			
			db_char_names = self.guild.characters.collect {|c| c.name}
			
			# Calculate new/missing chars
      missing_char_names = db_char_names - arsenal_char_names
      new_char_names = arsenal_char_names - db_char_names
      
      # Add new chars
      unless new_char_names.empty?
        arsenal_chars.each do |char|
          if new_char_names.include?(char.name) then
            event = Event.new(:action => 'joined')
            event.guild = self.guild
            
            exist_char = Character.find_all_by_name(char.name)
            unless exist_char.empty?
              char = exist_char.first
              char.update_attribute(:guild_id,id)
            end
            
            event.character = char
            event.save
          end
        end
      end

      #Delete missing chars
      unless missing_char_names.empty?
        characters.each do |char|
          if missing_char_names.include?(char.name) then
            event = Event.new(:action => 'left')
            event.character = char
            event.guild = self.guild
            event.save
            char.update_attribute(:guild_id, nil)
          end
        end
      end
		  
    else
      #throw a exception
    end
  end
  
  def update_guild_onlinelist(uri)
    uri = "http://www.rising-gods.de/components/com_onlinelist/views/onlinelist/ajax_request.php?server=pve" if uri.nil?
    doc = get_html(uri)
    
    
    self.guild.characters.each do |char|
      newonline = doc.include?(">#{char.name}<")
      attributes = Hash.new
      if char.online == true && newonline == true then
        char.activity = 0 if char.activity.nil?
        if char.last_seen.nil? then
          attributes[:last_seen] = Time.now
          char.last_seen = Time.now
        end 
        attributes[:activity] = char.activity + 1 unless (char.last_seen + 1.hour) > Time.now 
      elsif char.online == true && newonline == false then
        attributes[:last_seen] = Time.now
      end
      attributes[:online] = newonline
      char.update_attributes!(attributes)
    end
    
  end
  
  def get_html(uri)
    response = open(uri)
    return response.read
  end
  
  def get_xml(uri)
    response = open(uri)
    
    doc = Hpricot.XML(response)
		errors = doc.search("*[@errCode]")
		if errors.size > 0
			errors.each do |error|
				raise error[:errCode]
			end
		elsif (doc%'page').nil?
			raise "EmptyPage"
		else
			return (doc%'page')
		end
	end
end
