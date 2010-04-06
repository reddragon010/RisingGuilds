require "open-uri"
require "hpricot"

class RemoteQuery < ActiveRecord::Base
  belongs_to :guild
  belongs_to :character
  
  validates_presence_of :priority
  validates_presence_of :efford
  validates_presence_of :action
  
  def execute
    self.send(self.action)
  end
  
  def update_guild(uri=nil)
    xml = get_xml(RAILS_ROOT + "/test/files/guild.xml") if uri.nil?
    
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
