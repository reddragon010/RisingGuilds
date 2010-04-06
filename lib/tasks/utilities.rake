desc "execute the queryqueue"
task :queryqueue_run => :environment do
  queries = RemoteQuery.find(:all,:order => "created_at ASC, priority", :limit => 100)
  effordcounter = 0
  queries.each do |query| 
    puts "Query No. #{query.id} - executing #{query.action}"
    query.execute
    effordcounter += query.efford
    break if effordcounter >= 100
  end
end