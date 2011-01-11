# encoding: utf-8
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
    guild.assignments << Assignment.create(:user_id => raidleader.id, :guild_id => guild.id, :role => 'raidleader')
    guild.raidleaders.first.should == raidleader
  end
  
  it "should know its leaders" do
    guild = Factory(:Guild)
    leader = Factory(:User)
    guild.assignments << Assignment.create(:user_id => leader.id, :guild_id => guild.id, :role => 'leader')
    guild.leaders.first.should == leader
  end
  
  it "should know its officers" do
    guild = Factory(:Guild)
    officer = Factory(:User)
    guild.assignments << Assignment.create(:user_id => officer.id, :guild_id => guild.id, :role => 'officer')
    guild.officers.first.should == officer
  end
  
  it "should know its members" do
    guild = Factory(:Guild)
    member = Factory(:User)
    guild.assignments << Assignment.create(:user_id => member.id, :guild_id => guild.id, :role => 'member')
    guild.members.first.should == member
  end
  
  it "should can be destroyed cleanly" do
    guild = Factory(:Guild)
    guild2 = Factory(:Guild)
    guild_id = guild.id
    
    member = Factory(:User)
    guild.assignments << Assignment.create(:user_id => member.id, :guild_id => guild.id, :role => 'leader')
    
    raid = Factory(:Raid, :guild_id => guild.id)
    raid.guilds << guild
    raid2 = Factory(:Raid, :guild_id => guild2.id)
    raid2.guilds << guild2
    raid2.guilds << guild
    
    event = Factory(:Event)
    guild.events << event
    
    guild.reload
    guild.users.count.should == 1
    guild.raids.count.should == 2
    Raid.find_all_by_guild_id(guild_id).count.should == 1
    guild.events.count.should == 1
    
    guild.destroy
    
    Assignment.all.count.should == 0
    Raid.find_all_by_guild_id(guild_id).count.should == 0
    Event.all.count.should == 0
  end
  
  it "should can sync with arsenal" do
    guild = Factory.create(:Guild)
    guild.characters << Factory.create(:Character, :name => "Notexistingchar_d")
    guild.sync
    guild.reload
    guild.characters.count.should == 36
    guild.characters.find_by_name("Notexistingchar_d").should be_nil
  end
  
  #test for Error #17 ... existing chars don't get added to guilds
  it "should add existing chars to the correct guild" do
    Factory.create(:Guild)
    guild = Factory.create(:Guild)
    char = Factory.create(:Character, :name => "Kohorn")
    guild.sync
    guild.reload
    guild.characters.count.should == 36
    guild.characters.find_by_name("Kohorn").should == char
  end
  
  #pro/demote on guild_update
  it "should update the rank and trigger the pro/demote-event" do
    guild = Factory.create(:Guild)
    guild.characters << Factory.create(:Character)
    guild.sync
    guild.reload
    guild.characters.find_by_name("Kohorn").rank.should == 0
    guild.characters.find_by_name("Illandra").rank.should == 2
    guild.characters.find_by_name("Liezzy").rank.should == 1
    configatron.arsenal.url.guild.info = 'guild_rank.xml'
    guild.sync
    guild.reload
    guild.events.count.should > 0
    char = guild.characters.find_by_name("Kohorn")
    char.rank.should == 1
    char.events.last.action == "demoted"
    char = guild.characters.find_by_name("Illandra")
    char.rank.should == 0
    char.events.last.action == "promoted"
    char = guild.characters.find_by_name("Liezzy")
    char.rank.should == 2
    char.events.last.action == "demoted"
  end
  
  #don't trigger join-event on guild-creation
  it "shouldn't trigger the join-event on guild creation" do
    configatron.arsenal.test = false
    guild = Factory.create(:Guild, :name => "tguild", :serial => Digest::SHA1.hexdigest("tguild:#{configatron.guilds.serial_salt}"))
    guild.sync
    guild.reload
    guild.events.count.should == 0
  end
  
  it "should trigger the join-event on normal update" do
    configatron.arsenal.test = true
    guild = Factory.create(:Guild)
    guild.characters << Factory.create(:Character)
    guild.sync
    guild.reload
    guild.events.count.should > 0
  end
  
  #add guild-name as content on join- and left-events
  it "should add guild-name to event-content on join" do
    guild = Factory.create(:Guild)
    guild.characters << Factory.create(:Character)
    guild.sync
    guild.reload
    guild.events.first.content.should == guild.name
  end
  
  it "should add guild-name to event-content on left" do
    guild = Factory.create(:Guild)
    character = Factory.create(:Character)
    guild.characters << character
    guild.sync
    guild.reload
    character.events.last.content.should == guild.name
  end
  
  #special-signs bug
  it "shouldn't kick umlaut-chars" do
    guild = Factory.create(:Guild)
    guild.sync
    guild.events.count == 0
    guild.sync
    guild.events.count == 0
    guild.reload
    guild.characters.count.should == 36
    guild.characters.find_by_name("Notexistingchar_d").should be_nil
  end
  
  it "should calculate AIL" do
    guild = Factory.create(:Guild)
    guild.sync
    guild.reload
    guild.characters.each{|c| c.update_attribute(:ail, 200)}
    guild.ail.should == 200
  end
  
  it "should calculate average-level" do
    guild = Factory.create(:Guild)
    guild.sync
    guild.reload
    guild.acl.should == 59
  end
end
