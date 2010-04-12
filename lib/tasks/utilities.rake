namespace :queryqueue do
  desc "execute the queryqueue"
  task :run => :environment do
    queries = RemoteQuery.find(:all,:order => "created_at ASC, priority", :limit => 100)
    effordcounter = 0
    queries.each do |query| 
      puts "Query No. #{query.id} - executing #{query.action}"
      query.execute
      effordcounter += query.efford
      break if effordcounter >= 100
    end
  end
  
  task :clear => :environment do
    RemoteQuery.all.each do |rq| 
      puts "Destroy RemoteQuery No. #{rq.id}"
      puts y rq
      rq.destroy
    end
  end
end

namespace :onlinestatus do
  task :update => :environment do
    doc = get_html("http://www.rising-gods.de/components/com_onlinelist/views/onlinelist/ajax_request.php?server=pve")
    
    raise "Can't get Onlinelist" unless doc.include?('<a href="javascript:AjaxRequest(\'pvp\');"><img src=\'/components/com_onlinelist/views/onlinelist/tmpl/img/pvp_deactiv.gif\'></a>&nbsp;<a href="javascript:AjaxRequest(\'pve\');"><img src=\'/components/com_onlinelist/views/onlinelist/tmpl/img/pve_activ.gif\'></a>')
    
    #process every character
    Character.all.each do |char|
      #test if char is online
      newonline = doc.include?(">#{char.name}<")
      attributes = Hash.new
      
      char.online = false if char.online.nil?
      
      #if char stay online
      if char.online == true && newonline == true then
        #workaround: default activity is nil not 0
        char.activity = 0 if char.activity.nil?
        #If user was still a hour online adds 1 to activity
        attributes[:activity] = char.activity + 1 unless (char.last_seen + 1.hour) >= Time.now 
        puts "#{char.name} is still online"
      #if char has been gone offline
      elsif char.online == true && newonline == false then
        attributes[:last_seen] = Time.now
        attributes[:online] = false
        puts "#{char.name} has been gone offline"
      #if char comes online
      elsif char.online == false && newonline == true
        attributes[:last_seen] = Time.now
        attributes[:online] = true
        puts "#{char.name} has come online"
      end
      char.update_attributes!(attributes) unless attributes.empty?
    end
  end
  
  def get_html(url)
    return open(url).read if !url.include?("http://")
    
    req = Net::HTTP::Get.new(url)
		req["user-agent"] = "Mozilla/5.0 Gecko/20070219 Firefox/2.0.0.2" # ensure returns XML
		
		uri = URI.parse(url)
		
		http = Net::HTTP.new(uri.host, uri.port)
	  
		begin
		  http.start do
		    res = http.request req
				# response = res.body
				
				tries = 0
				response = case res
					when Net::HTTPSuccess, Net::HTTPRedirection
						res.body
					else
						tries += 1
						if tries > 10
							raise 'Timed out'
						else
							retry
						end
					end
		  end
		rescue
			raise 'Specified server at ' + url + ' does not exist.'
		end
  end
end