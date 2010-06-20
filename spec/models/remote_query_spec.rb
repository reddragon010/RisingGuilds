require 'spec_helper'

describe RemoteQuery do
  before(:each) do
  end

  it "should create a new instance given valid attributes" do
    Factory.create(:RemoteQuery)
  end
  
  it "should can update guilds" do
    @guild = Factory.create(:Guild)
    @guild.characters << Factory.create(:Character, :name => "Notexistingchar_d")
    @guild.remoteQueries << Factory.create(:RemoteQuery, :action => "update_guild")
    @guild.remoteQueries.first.execute.should be_true
    @guild.remoteQueries.count.should == 0
    @guild = Guild.find(@guild.id)
    @guild.characters.count.should == 36
    @guild.characters.find_by_name("Notexistingchar_d").should be_nil
  end
  
  it "should can update still online characters and raise activity" do
    @guild = Factory.create(:Guild)
    @guild.characters << Factory.create(:Character, :name => "Nerox")
    staychar = @guild.characters.find_by_name("Nerox")
    staychar.name.should == "Nerox"
    staychar.update_attributes(:online => true, :last_seen => 13.hour.ago)
    @guild = Guild.find(@guild.id)
    @guild.characters.find_all_by_online(true).count.should == 1
    @guild.remoteQueries << Factory.create(:RemoteQuery, :action => "update_guild_onlinelist")
    @guild.remoteQueries.first.execute.should be_true  
    @guild = Guild.find(@guild.id)
    Character.find_by_name("Nerox").activity.should == 2
    @guild.characters.find_all_by_online(true).count.should == 1
    @guild.remoteQueries << Factory.create(:RemoteQuery, :action => "update_guild_onlinelist")
    @guild.remoteQueries.first.execute.should be_true 
    Character.find_by_name("Nerox").activity.should == 3
  end
  
  it "should can update gone-offline characters" do
     @guild = Factory.create(:Guild)
     @guild.characters << Factory.create(:Character, :name => "Ugmar")
     onchar = @guild.characters.find_by_name("Ugmar")
     onchar.name.should == "Ugmar"
     onchar.update_attributes(:online => true, :last_seen => 2.hour.ago)
     @guild = Guild.find(@guild.id)
     @guild.characters.find_all_by_online(true).count.should == 1
     @guild.remoteQueries << Factory.create(:RemoteQuery, :action => "update_guild_onlinelist")
     @guild.remoteQueries.first.execute.should be_true  
     @guild = Guild.find(@guild.id)
     @guild.characters.find_all_by_online(true).count.should == 0
   end
   
   it "should can update coming-online characters" do
      @guild = Factory.create(:Guild)
      @guild.characters << Factory.create(:Character, :name => "Nerox")
      @guild.characters << Factory.create(:Character, :name => "Merlinia")
      @guild.remoteQueries << Factory.create(:RemoteQuery, :action => "update_guild_onlinelist")
      @guild.remoteQueries.first.execute.should be_true
      @guild = Guild.find(@guild.id)
      @guild.characters.find_all_by_online(true).count.should == 2
    end
     
    it "should update characters on update_character" do
      @char = Factory.create(:Character,:name => "Nerox")
      @char.remoteQueries << Factory.create(:RemoteQuery, :action => "update_character")
      @char.remoteQueries.first.execute.should be_true
      @char = Character.find(@char.id)
      @char.achivementpoints.should == 1425
      @char.level.should == 77
      @char.talentspec1.class.should == Character::TalentSpec
      @char.talentspec2.class.should == Character::TalentSpec
      @char.items.first.class.should == Character::Item
      @char.profession1.class.should == Character::Profession
      @char.profession2.class.should == Character::Profession
    end
    
    it "should update the ail of a character" do
      @char = Factory.create(:Character,:name => "Nerox")
      @char.remoteQueries << Factory.create(:RemoteQuery, :action => "update_character")
      @char.remoteQueries.first.execute.should be_true
      @char = Character.find(@char.id)
      @char.remoteQueries << Factory.create(:RemoteQuery, :action => "update_character_ail")
      @char.remoteQueries.first.execute.should be_true
      @char = Character.find(@char.id)
      @char.ail.should == 129
    end
    
    #test for Error #17 ... existing chars don't get added to guilds
    it "should add existing chars to the correct guild" do
      Factory.create(:Guild)
      @guild = Factory.create(:Guild)
      @char = Factory.create(:Character, :name => "Kohorn")
      @guild.remoteQueries << Factory.create(:RemoteQuery, :action => "update_guild")
      @guild.remoteQueries.first.execute.should be_true
      @guild.remoteQueries.count.should == 0
      @guild = Guild.find(@guild.id)
      @guild.characters.count.should == 36
      @guild.characters.find_by_name("Kohorn").should == @char
    end
    
    #test for Error #13 ... double-levelup-events
    it "shoud update the level and trigger the event ONCE" do
      @char = Factory.create(:Character,:name => "Nerox")
      @char.remoteQueries << Factory.create(:RemoteQuery, :action => "update_character")
      @char.remoteQueries.first.execute.should be_true
      @char.reload
      @char.level.should == 77
      configatron.arsenal.url.character.sheet = 'char_levelup.xml'
      @char.remoteQueries << Factory.create(:RemoteQuery, :action => "update_character")
      @char.remoteQueries.first.execute.should be_true
      @char.reload
      @char.level.should == 78
      @event = @char.events.last
      @event.action.should == "levelup"
      @char.remoteQueries << Factory.create(:RemoteQuery, :action => "update_character")
      @char.remoteQueries.first.execute.should be_true
      @char.reload
      @char.events.last.should == @event
    end
    
    #pro/demote on guild_update
    it "shoud update the rank and trigger the pro/demote-event" do
      @guild = Factory.create(:Guild)
      @guild.remoteQueries << Factory.create(:RemoteQuery, :action => "update_guild")
      @guild.remoteQueries.first.execute.should be_true
      @guild.remoteQueries.count.should == 0
      @guild.reload
      @guild.characters.find_by_name("Kohorn").rank.should == 0
      @guild.characters.find_by_name("Illandra").rank.should == 2
      @guild.characters.find_by_name("Liezzy").rank.should == 1
      configatron.arsenal.url.guild.info = 'guild_rank.xml'
      @guild.remoteQueries << Factory.create(:RemoteQuery, :action => "update_guild")
      @guild.remoteQueries.first.execute.should be_true
      @guild.remoteQueries.count.should == 0
      @guild.reload
      @char = @guild.characters.find_by_name("Kohorn")
      @char.rank.should == 1
      @char.events.last.action == "demoted"
      @char = @guild.characters.find_by_name("Illandra")
      @char.rank.should == 0
      @char.events.last.action == "promoted"
      @char = @guild.characters.find_by_name("Liezzy")
      @char.rank.should == 2
      @char.events.last.action == "demoted"
    end
    
    it "should calculate all guild-indicators" do
      @guild = Factory.create(:Guild)
      @guild.remoteQueries << Factory.create(:RemoteQuery, :action => "update_guild")
      @guild.remoteQueries.first.execute.should be_true
      
      @guild.characters.find(:all,:limit => 6).each{|char| char.update_attribute(:main,true)}
      
      @guild.characters.each_with_index{|char,i| char.update_attribute(:ail,200-i)}
      
      @guild.remoteQueries << Factory.create(:RemoteQuery, :action => "update_guild_indicators")
      @guild.remoteQueries.each{|q| q.execute.should be_true}
      @guild.remoteQueries.count.should == 0
      @guild.reload
      
      @guild.altratio.should == 80
      @guild.ail.should == 182
      
    end
end
