namespace :sync do  
  desc "fill the queryqueue with update-character-requests"
  task :characters => :environment do
    Character.all.each do |char|
      char.delay.sync
    end
  end
  
  desc "fill the queryqueue with update-guild-requests"
  task :guilds => :environment do
    Guild.find_all_by_verified(true).each do |guild|
      guild.delay.sync
    end
  end
end