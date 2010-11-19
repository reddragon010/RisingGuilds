namespace :statistics do
  desc "generate the daily guild-statistic events"
  task :generate_daily => :environment do
    Guild.all.each do |guild|
      guild.events << Event.create(:action => "today_online", :visible => false, :content => guild.characters.online_today.count)
    end
  end
  
  desc "generate the weekly guild-statistic events"
  task :generate_weekly => :environment do
    Guild.all.each do |guild|
      guild.events << Event.create(:action => "weekly_ail", :visible => false, :content => guild.ail)
      guild.events << Event.create(:action => "weekly_members", :visible => false, :content => guild.characters.count)
    end
  end
end