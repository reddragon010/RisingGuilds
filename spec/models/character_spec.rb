require 'spec_helper'

describe Character do
  before(:each) do
  end

  it "should create a new instance given valid attributes" do
    Factory.create(:Character)
  end
  
  it "should can be linked to a guild" do
    guild = Guild.first || Factory.create(:Guild)
    character = Factory.create(:Character)
    character.guild = guild
    character.guild.name.should == guild.name
  end
  
  it "should self-update on sync" do
    char = Factory.create(:Character,:name => "Nerox")
    char.sync
    char.reload
    char.achivementpoints.should == 1425
    char.level.should == 77
    char.talentspec1.class.should == Arsenal::TalentSpec
    char.talentspec2.class.should == Arsenal::TalentSpec
    char.items.first.class.should == Arsenal::Item
    char.profession1.class.should == Arsenal::Profession
    char.profession2.class.should == Arsenal::Profession
  end
  
  it "should update the ail of a character" do
    char = Factory.create(:Character,:name => "Nerox")
    char.sync
    char.sync_ail
    char.reload
    char.ail.should == 137
  end
  
  #test for Error #13 ... double-levelup-events
  it "should update the level and trigger the event ONCE" do
    char = Factory.create(:Character,:name => "Nerox")
    char.sync
    char.reload
    char.level.should == 77
    configatron.arsenal.url.character.sheet = 'char_levelup.xml'
    char.sync
    char.reload
    char.level.should == 78
    event = char.events.last
    event.action.should == "levelup"
    char.sync
    char.reload
    char.events.last.should == event
  end
  
  #testing DivisionByZero-Bug on AIL-Sync
  it "should not set the ail if no items equiped" do
    char = Factory.create(:Character,:name => "Nerox")
    char.sync
    char.sync_ail
    char.reload
    char.ail.should == 137
    configatron.arsenal.url.character.sheet = 'char_zeroitems.xml'
    char.sync_ail
    char.reload
    char.ail.should == 137
  end
  
  it "should not update the ail if no items equiped" do
    configatron.arsenal.url.character.sheet = 'char_zeroitems.xml'
    char = Factory.create(:Character,:name => "Nerox",:ail=>nil)
    char.sync
    char.sync_ail
    char.reload
    char.items.count.should == 0
    char.ail.should == nil
  end
  
  it "should update online-status if in onlinelist" do
    char = Factory.create(:Character, :name => "Nerox")
    char.online.should == false
    char.update_onlinestatus
    char.online.should == true
  end
  
  it "shouldn't update online-status if not in onlinelist" do
    char = Factory.create(:Character, :name => "NoChar")
    char.online.should == false
    char.update_onlinestatus
    char.online.should == false
  end
  
  it "should higher the activity if online in the last 3 days" do
    char = Factory.create(:Character, :name => "Nerox", :last_seen => 2.days.ago)
    activity = char.activity
    char.check_activity.should == activity + 1
  end
  
  it "should lower the activity if not online in the last 3 days" do
    char = Factory.create(:Character, :name => "Nerox", :activity => 3, :last_seen => 4.days.ago)
    char.check_activity.should == 2
  end
  
  it "activity should not get highter then 5" do
    char = Factory.create(:Character, :name => "Nerox", :activity => 5)
    char.check_activity.should == 5
  end
  
  it "activity should not get lower then 0" do
    char = Factory.create(:Character, :name => "Nerox", :activity => 0, :last_seen => 4.days.ago)
    char.check_activity.should == 0
  end
  
  it "activity should get updated if coming online" do
    char = Factory.create(:Character, :name => "Nerox", :activity => 3, :last_seen => 2.days.ago)
    char.update_onlinestatus
    char.reload
    char.activity.should == 4
    char.update_onlinestatus
    char.reload
    char.activity.should == 4
  end
  
  it "activity should get updated if going offline" do
    char = Factory.create(:Character, :name => "NoChar", :activity => 3, :last_seen => 2.days.ago, :online => true)
    char.update_onlinestatus
    char.reload
    char.activity.should == 4
    char.update_onlinestatus
    char.reload
    char.activity.should == 4
  end
  
  it "activity should only get updated once per day" do
    char = Factory.create(:Character, :name => "Nerox", :activity => 3, :last_seen => 2.days.ago)
    char.update_onlinestatus
    char.reload
    char.activity.should == 4
    char.online = false
    char.update_onlinestatus
    char.reload
    char.activity.should == 4
  end
end
