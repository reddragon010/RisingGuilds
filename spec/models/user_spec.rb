require 'spec_helper'

describe User do
  it "should create a new instance given valid attributes" do
    Factory(:User).valid?
  end
  
  it "should have some roles" do
    user = Factory(:User)
    guild1 = Factory(:Guild)
    guild2 = Factory(:Guild)
    user.assignments << Factory.create(:Assignment,{:guild_id => guild1.id, :role => 'leader'})
    user.assignments << Factory.create(:Assignment,{:guild_id => guild1.id, :role => 'member'})
    user.assignments << Factory.create(:Assignment,{:guild_id => guild1.id, :role => 'raidleader'})
    user.assignments << Factory.create(:Assignment,{:guild_id => guild2.id, :role => 'member'})
    user.reload
    user.roles.should == ['leader','member','raidleader','member']
  end
  
  it "should have role-symboles" do
    user = Factory(:User, :admin => true)
    guild1 = Factory(:Guild)
    guild2 = Factory(:Guild)
    user.assignments << Factory.create(:Assignment,{:guild_id => guild1.id, :role => 'leader'})
    user.assignments << Factory.create(:Assignment,{:guild_id => guild1.id, :role => 'member'})
    user.assignments << Factory.create(:Assignment,{:guild_id => guild1.id, :role => 'raidleader'})
    user.assignments << Factory.create(:Assignment,{:guild_id => guild2.id, :role => 'member'})
    user.reload
    user.role_symbols.should == [:admin,:leader,:member,:raidleader,:user]
  end
  
  it "should be kickable/promoteable by superiors" do
    user_slave = Factory.create(:User)
    user_master = Factory.create(:User)
    guild = Factory.create(:Guild)
    user_master.assignments << Factory.create(:Assignment,{:guild_id => guild.id, :role => 'leader'})
    user_slave.assignments << Factory.create(:Assignment,{:guild_id => guild.id, :role => 'officer'})
    user_slave.kickable_by?(user_master,guild).should == true
    user_slave.demoteable_by?(user_master,guild).should == true
    user_slave.promoteable_by?(user_master,guild).should == true
  end
  
  it "should not be demoteable if no lower rank exists" do
    user_slave = Factory.create(:User)
    user_master = Factory.create(:User)
    guild = Factory.create(:Guild)
    user_master.assignments << Factory.create(:Assignment,{:guild_id => guild.id, :role => 'leader'})
    user_slave.assignments << Factory.create(:Assignment,{:guild_id => guild.id, :role => 'member'})
    user_slave.demoteable_by?(user_master,guild).should == false
  end
  
  it "should not be promoteable of no highter rank exists" do
    user_slave = Factory.create(:User)
    user_master = Factory.create(:User)
    guild = Factory.create(:Guild)
    user_master.assignments << Factory.create(:Assignment,{:guild_id => guild.id, :role => 'leader'})
    user_slave.assignments << Factory.create(:Assignment,{:guild_id => guild.id, :role => 'leader'})
    user_slave.promoteable_by?(user_master,guild).should == false
  end
  
  it "shouldn't be kickable by themself if it's the only leader" do
    user = Factory.create(:User)
    guild = Factory.create(:Guild)
    user.assignments << Factory.create(:Assignment,{:guild_id => guild.id, :role => 'leader'})
    user.kickable_by?(user,guild).should == false
    user.demoteable_by?(user,guild).should == false
  end
end
