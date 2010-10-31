namespace :statistics do
  desc "generate the guild-statistic events"
  task :generate => :environment do
    Guild.all.each do |guild|
      online_chars = guild.characters.where("last_seen >= ? OR online == true", Time.now)
      puts online_chars
    end
  end
end