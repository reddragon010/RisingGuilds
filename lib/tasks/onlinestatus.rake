namespace :onlinestatus do
  desc "update the onlinestatus of all characters"
  task :update => :environment do
    doc = Hash.new
    doc['PvE-Realm'] = Arsenal::get_html(configatron.onlinelist.url + "pve")
    doc['PvP-Realm'] = Arsenal::get_html(configatron.onlinelist.url + "pvp")
    
    raise "Can't get PvE-Onlinelist" unless doc['PvE-Realm'].include?('<a href="javascript:AjaxRequest(\'pvp\');"><img src=\'/components/com_onlinelist/views/onlinelist/tmpl/img/pvp_deactiv.gif\'></a>&nbsp;<a href="javascript:AjaxRequest(\'pve\');"><img src=\'/components/com_onlinelist/views/onlinelist/tmpl/img/pve_activ.gif\'></a>') 
    raise "Can't get PvP-Onlinelist" unless doc['PvP-Realm'].include?('<a href="javascript:AjaxRequest(\'pvp\');"><img src=\'/components/com_onlinelist/views/onlinelist/tmpl/img/pvp_activ.gif\'></a>&nbsp;<a href="javascript:AjaxRequest(\'pve\');"><img src=\'/components/com_onlinelist/views/onlinelist/tmpl/img/pve_deactiv.gif\'></a>')
    
    #process every character
    Character.all.each do |char|
      #test if char is online
      newonline = doc[char.realm.to_s].include?(">#{char.name}<".force_encoding('ASCII-8BIT'))
      attributes = Hash.new
      
      char.online = false if char.online.nil?
      
      #if char stay online
      if char.online == true && newonline == true then
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
end

namespace :serial do
  desc "generate a valid serial"
  task :generate => :environment do
    puts Digest::SHA1.hexdigest("#{ENV['guild_name']}:#{configatron.guilds.serial_salt}")
  end
end