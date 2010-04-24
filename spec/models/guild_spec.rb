require 'spec_helper'

describe Guild do
  before(:each) do
  end

  it "should create a new instance given valid attributes" do
    Factory.create(:Guild)
  end
  
  it "should know its characters" do
    @guild = Factory.create(:Guild)
    @characters = [Factory.create(:Character),Factory.create(:Character)]
    @guild.characters << @characters
    @guild.characters.count.should == 2
  end
  
  it "should can get some RemoteQueries" do
    @guild = Factory.create(:Guild)
    @remotequeries = [Factory.create(:RemoteQuery),Factory.create(:RemoteQuery)]
    @guild.remoteQueries << @remotequeries
    @guild.remoteQueries.count.should == 2
  end
  
  it "shouldn't accept a description with lesser then 100 Characters" do
    @guild = Factory.build(:Guild, :description => "Too short man!!")
    @guild.valid?.should be_false
    @guild.should have_at_least(1).error_on(:description)
  end
  
  it "should not be valid without a name" do
    @guild = Factory.build(:Guild, :name => "")
    @guild.valid?.should be_false
    @guild.should have_at_least(1).error_on(:name)
  end
  
  it "should not be valid without a token" do
    @guild = Factory.build(:Guild, :token => "")
    @guild.valid?.should be_false
    @guild.should have_at_least(1).error_on(:token)
  end
  
  it "should know its managers" do
    @guild = Factory(:Guild)
    Factory(:Role,:name => 'guildmanager')
    manager = Factory(:User)
    @guild.assignments << Assignment.create(:user_id => manager.id, :guild_id => @guild.id, :role_id => Role.find_by_name('guildmanager'))
    @guild.managers.first.should == manager
  end
  
  it "should know its leaders" do
    @guild = Factory(:Guild)
    Factory(:Role,:name => 'guildleader')
    leader = Factory(:User)
    @guild.assignments << Assignment.create(:user_id => leader.id, :guild_id => @guild.id, :role_id => Role.find_by_name('guildleader'))
    @guild.leaders.first.should == leader
  end
  
  it "should know its officers" do
    @guild = Factory(:Guild)
    Factory(:Role,:name => 'guildofficer')
    officer = Factory(:User)
    @guild.assignments << Assignment.create(:user_id => officer.id, :guild_id => @guild.id, :role_id => Role.find_by_name('guildofficer'))
    @guild.officers.first.should == officer
  end
  
  it "should know its members" do
    @guild = Factory(:Guild)
    Factory(:Role,:name => 'guildmember')
    member = Factory(:User)
    @guild.assignments << Assignment.create(:user_id => member.id, :guild_id => @guild.id, :role_id => Role.find_by_name('guildmember'))
    @guild.members.first.should == member
  end
  
end
