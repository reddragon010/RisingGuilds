namespace :onlinestatus do
  desc "update the onlinestatus of all characters"
  task :update => :environment do
    doc = Hash.new
    doc['PvE-Realm'] = ServerStatus.new(configatron.onlinelist.pve)
    doc['PvP-Realm'] = ServerStatus.new(configatron.onlinelist.pvp)
    
    raise "Can't get PvE-Onlinelist" unless doc['PvE-Realm'].ok?
    raise "Can't get PvP-Onlinelist" unless doc['PvP-Realm'].ok?
    
    #process every character
    Character.all.each do |char|
      #test if char is online
      newonline = doc[char.realm.to_s].user_online?("#{char.name}")
      attributes = Hash.new
      
      char.online = false if char.online.nil?
      
      #if char stay online
      if char.online == true && newonline == true then 
        attributes[:last_seen] = Time.now
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
      char.check_activity unless char.online == false && newonline == false
    end
  end
end
