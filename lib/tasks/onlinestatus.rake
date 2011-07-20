namespace :onlinestatus do
  desc "update the onlinestatus of all characters"
  task :update => :environment do
    #process every character
    Character.all.each do |char|
      newonline = char.update_onlinestatus
      #if char stay online
      if char.online == true && newonline == true then 
        puts "#{char.name} is still online"
      #if char has been gone offline
      elsif char.online == true && newonline == false then
        puts "#{char.name} has been gone offline"
      #if char comes online
      elsif char.online == false && newonline == true
        puts "#{char.name} has come online"
      end
    end
  end
end
