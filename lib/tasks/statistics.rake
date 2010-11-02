namespace :statistics do
  desc "generate the guild-statistic events"
  task :generate => :environment do
    Guild.all.each do |guild|
      guild.events << Event.create(:action => "today_online", :visible => false, :content => guild.characters.online_today.count)
    end
  end
end