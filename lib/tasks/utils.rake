namespace :serial do
  desc "generate a valid serial"
  task :generate => :environment do
    puts Digest::SHA1.hexdigest("#{ENV['guild_name']}:#{configatron.guilds.serial_salt}")
  end
end