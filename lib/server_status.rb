class ServerStatus
    def initialize(url)
      @url = url
      self.get_xml()
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
    
    def get_xml()
      @doc = Nokogiri::XML(open(@url))
    end
end