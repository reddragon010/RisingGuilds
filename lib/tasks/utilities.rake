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