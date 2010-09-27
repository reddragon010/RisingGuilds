require 'spec_helper'

describe Guild do
  fixtures :roles

  it "should create a new instance given valid attributes" do
    guild = Factory.create(:Guild)
  end
  
  it "should know its characters" do
    guild = Factory.create(:Guild)
    characters = [Factory.create(:Character),Factory.create(:Character)]
    guild.characters << characters
    guild.characters.count.should == 2
  end
  
  it "should can get some RemoteQueries" do
    guild = Factory.create(:Guild)
    remotequeries = [Factory.create(:RemoteQuery),Factory.create(:RemoteQuery)]
    guild.remoteQueries << remotequeries
    guild.remoteQueries.count.should == 2
  end
  
  it "shouldn't accept a description with lesser then 100 Characters" do
    guild = Factory.build(:Guild, :description => "Too short man!!")
    guild.valid?.should be_false
    guild.should have_at_least(1).error_on(:description)
  end
  
  it "should not be valid without a name" do
    guild = Factory.build(:Guild, :name => "")
    guild.valid?.should be_false
    guild.should have_at_least(1).error_on(:name)
  end
  
  it "should not be valid without a token" do
    guild = Factory.build(:Guild, :token => "")
    guild.valid?.should be_false
    guild.should have_at_least(1).error_on(:token)
  end
  
  it "should know its raidleaders" do
    guild = Factory(:Guild)
    raidleader = Factory(:User)
    guild.assignments << Assignment.create(:user_id => raidleader.id, :guild_id => guild.id, :role_id => Role.where(:name => 'raidleader').first.id)
    guild.raidleaders.first.should == raidleader
  end
  
  it "should know its leaders" do
    guild = Factory(:Guild)
    leader = Factory(:User)
    guild.assignments << Assignment.create(:user_id => leader.id, :guild_id => guild.id, :role_id => Role.where(:name => 'leader').first.id)
    guild.leaders.first.should == leader
  end
  
  it "should know its officers" do
    guild = Factory(:Guild)
    officer = Factory(:User)
    guild.assignments << Assignment.create(:user_id => officer.id, :guild_id => guild.id, :role_id => Role.where(:name => 'officer').first.id)
    guild.officers.first.should == officer
  end
  
  it "should know its members" do
    guild = Factory(:Guild)
    member = Factory(:User)
    guild.assignments << Assignment.create(:user_id => member.id, :guild_id => guild.id, :role_id => Role.where(:name => 'member').first.id)
    guild.members.first.should == member
  end
  
  it "should can be destroyed cleanly" do
    guild = Factory(:Guild)
    guild2 = Factory(:Guild)
    guild_id = guild.id
    
    member = Factory(:User)
    Factory(:Role,:name => 'leader')
    guild.assignments << Assignment.create(:user_id => member.id, :guild_id => guild.id, :role_id => Role.find_by_name('leader'))
    
    raid = Factory(:Raid, :guild_id => guild.id)
    raid.guilds << guild
    raid2 = Factory(:Raid, :guild_id => guild2.id)
    raid2.guilds << guild2
    raid2.guilds << guild
    
    event = Factory(:Event)
    guild.events << event
    
    rq = Factory(:RemoteQuery)
    guild.remoteQueries << rq
    
    guild.reload
    guild.users.count.should == 1
    guild.raids.count.should == 2
    Raid.find_all_by_guild_id(guild_id).count.should == 1
    guild.events.count.should == 1
    guild.remoteQueries.count.should == 1
    
    guild.destroy
    
    Assignment.all.count.should == 0
    Raid.find_all_by_guild_id(guild_id).count.should == 0
    Event.all.count.should == 0
    RemoteQuery.all.count.should == 0
  end
end
