class ServerStatus
    @@instances = {}
    
    def ServerStatus.instance(name)
      if @@instances[name].nil? then
        @@instances[name] = ServerStatus.new(name)
      end
      return @@instances[name]
    end
  
    def initialize(name)
      @realm = configatron.realms[name]
      @status_url = @realm[:status_url]
      self.get_status_xml()
      raise "Can't get #{name} Onlinelist" unless self.ok?
    end
    
    def user_online?(name)
      search_result = @doc.xpath("//name[contains(.,'#{name}')]")
      if search_result.one? && search_result.children.text == name then
        return true
      else
        return false
      end
    end
    
    def ok?
      @doc.errors.empty?
    end
    
    def get_status_xml()
      @doc = Nokogiri::XML(open(@status_url))
    end
end