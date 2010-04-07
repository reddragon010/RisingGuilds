require 'spec_helper'

describe RemoteQuery do
  before(:each) do
  end

  it "should create a new instance given valid attributes" do
    Factory.create(:RemoteQuery)
  end
  
  it "should can update guilds" do
    @guild = Factory.create(:Guild)
    @guild.remoteQueries << Factory.create(:RemoteQuery, :action => "update_guild")
    @guild.remoteQueries.first.execute(RAILS_ROOT + "/test/files/guild.xml").should be_true
    @guild.remoteQueries.count.should == 0
    @guild = Guild.first
    @guild.characters.count.should == 36
  end
  
  it "should can update still online characters and raise activity" do
    @guild = Factory.create(:Guild)
    @guild.characters << Factory.create(:Character, :name => "Nerox")
    staychar = @guild.characters.find_by_name("Nerox")
    staychar.name.should == "Nerox"
    staychar.update_attributes(:online => true, :last_seen => 2.hour.ago)
    @guild = Guild.find_by_id(@guild.id)
    @guild.characters.find_all_by_online(true).count.should == 1
    @guild.remoteQueries << Factory.create(:RemoteQuery, :action => "update_guild_onlinelist")
    @guild.remoteQueries.first.execute(RAILS_ROOT + "/test/files/onlinelist.html").should be_true  
    @guild = Guild.find_by_id(@guild.id)
    Character.find_by_name("Nerox").activity.should == 2
    @guild.characters.find_all_by_online(true).count.should == 1
    @guild.remoteQueries << Factory.create(:RemoteQuery, :action => "update_guild_onlinelist")
    @guild.remoteQueries.first.execute(RAILS_ROOT + "/test/files/onlinelist.html").should be_true 
    Character.find_by_name("Nerox").activity.should == 3
  end
  
  it "should can update gone-offline characters" do
     @guild = Factory.create(:Guild)
     @guild.characters << Factory.create(:Character, :name => "Ugmar")
     onchar = @guild.characters.find_by_name("Ugmar")
     onchar.name.should == "Ugmar"
     onchar.update_attributes(:online => true, :last_seen => 2.hour.ago)
     @guild = Guild.find_by_id(@guild.id)
     @guild.characters.find_all_by_online(true).count.should == 1
     @guild.remoteQueries << Factory.create(:RemoteQuery, :action => "update_guild_onlinelist")
     @guild.remoteQueries.first.execute(RAILS_ROOT + "/test/files/onlinelist.html").should be_true  
     @guild = Guild.find_by_id(@guild.id)
     @guild.characters.find_all_by_online(true).count.should == 0
   end
   
   it "should can update coming-online characters" do
       @guild = Factory.create(:Guild)
       @guild.characters << Factory.create(:Character, :name => "Nerox")
       @guild.characters << Factory.create(:Character, :name => "Merlinia")
       @guild = Guild.find_by_id(@guild.id)
       @guild.characters.find_all_by_online(true).count.should == 0
       @guild.remoteQueries << Factory.create(:RemoteQuery, :action => "update_guild_onlinelist")
       @guild.remoteQueries.first.execute(RAILS_ROOT + "/test/files/onlinelist.html").should be_true  
       @guild = Guild.find_by_id(@guild.id)
       @guild.characters.find_all_by_online(true).count.should == 2
     end
end
