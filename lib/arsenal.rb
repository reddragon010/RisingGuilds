module Arsenal
  class TalentSpec
  	attr_reader :trees,:active,:group,:icon,:prim

  	def initialize(elem)
  		@trees = []
  		@trees[1] = elem[:treeOne].to_i
  		@trees[2] = elem[:treeTwo].to_i
  		@trees[3] = elem[:treeThree].to_i

      @active = elem[:active].nil? ? false : true
      @group  = elem[:group].to_i
      @icon   = elem[:icon]
      @prim   = elem[:prim]
  	end
  end

  class Profession
  	attr_reader :key, :name, :value, :max, :id
  	alias_method :to_s, :name
  	alias_method :to_i, :value

  	def initialize(elem)
  	  @id     = elem[:id]
  		@key 		= elem[:key]
  		@name 	= elem[:name]
  		@value 	= elem[:value].to_i
  		@max 		= elem[:max].to_i
  	end
  end

  class Item
  	attr_reader :id, :icon, :level, :slot

  	def initialize(elem)
  		@id 				= elem[:id].to_i
  		@icon 	    = elem[:icon]
  		@slot       = elem[:slot].to_i
  	end
  	
  	def level=(level)
  	  @level = level
	  end
  end
  
  def self.get_character_xml(character)
    url = configatron.arsenal.url.base 
    url += configatron.arsenal.url.character.sheet 
    if configatron.arsenal.test.nil?
      url += "?" + configatron.arsenal.url.realm
      url += character.realm + "&"
      url += configatron.arsenal.url.character.name
      url += CGI.escape(character.name) 
    end
    
    return get_xml(url)
  end
  
  def self.get_guild_xml(guild)
    # http://arsenal.rising-gods.de/ guild-info.xml ? r= #{self.guild.realm} gn= #{CGI.escape(self.guild.name)}
    url = configatron.arsenal.url.base 
    url += configatron.arsenal.url.guild.info 
    if configatron.arsenal.test.nil?
      url += '?' + configatron.arsenal.url.realm 
      url += guild.realm + "&"
      url += configatron.arsenal.url.guild.name
      url += CGI.escape(guild.name)
    end

    return get_xml(url)
  end
  
  def self.get_item_xml(item)
    #http://www.wowhead.com/ item= <itemid> &xml
    url = configatron.wowhead.url.base
    url += configatron.wowhead.url.item.prefix
    
    return get_xml(url + item.id.to_s + configatron.wowhead.url.item.suffix, 'wowhead')
  end
  
  #get the HTML-Code from URI
  def self.get_html(url)
    return open(url).read if !url.include?("http://")

    req = Net::HTTP::Get.new(url)
  	req["user-agent"] = "Mozilla/5.0 Gecko/20070219 Firefox/2.0.0.2" # ensure returns XML

  	uri = URI.parse(url)

  	http = Net::HTTP.new(uri.host, uri.port)

    tries = 10 
  	begin
  	  http.start do
  	    res = http.request req
  			# response = res.body

  			case res
  				when Net::HTTPSuccess, Net::HTTPRedirection
  					return res.body
  				else
  					tries -= 1
  			end
  	  end
  	rescue
  	  retry if tries > 0
  		raise 'Specified server at ' + url + ' does not exist or timed out.'
  	end
  end

  #get the preprocessed XML-Code from URI
  def self.get_xml(url, base='page')
    doc = Nokogiri::XML(get_html(url))
  	if doc.xpath(base).nil?
  		raise "EmptyPage (#{url})"
  	else
  		return doc.xpath(base)
  	end
  end
end