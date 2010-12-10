require 'spec_helper'

describe User do
  it "should create a new instance given valid attributes" do
    Factory(:User).valid?
  end
  
  it "should have some roles" do
    user = Factory(:User)
    guild1 = Factory(:Guild)
    guild2 = Factory(:Guild)
    user.assignments << Factory.create(:Assignment,{:guild_id => guild1.id, :role => 'Leader'})
    user.assignments << Factory.create(:Assignment,{:guild_id => guild1.id, :role => 'Member'})
    user.assignments << Factory.create(:Assignment,{:guild_id => guild1.id, :role => 'Raidleader'})
    user.assignments << Factory.create(:Assignment,{:guild_id => guild2.id, :role => 'Member'})
    user.reload
    user.roles.should == ['Leader','Member','Raidleader','Member']
  end
  
  it "should have role-symboles" do
    user = Factory(:User, :admin => true)
    guild1 = Factory(:Guild)
    guild2 = Factory(:Guild)
    user.assignments << Factory.create(:Assignment,{:guild_id => guild1.id, :role => 'Leader'})
    user.assignments << Factory.create(:Assignment,{:guild_id => guild1.id, :role => 'Member'})
    user.assignments << Factory.create(:Assignment,{:guild_id => guild1.id, :role => 'Raidleader'})
    user.assignments << Factory.create(:Assignment,{:guild_id => guild2.id, :role => 'Member'})
    user.reload
    user.role_symbols.should == [:admin,:leader,:member,:raidleader,:user]
  end
  
  it "should be kickable/demoteable/promoteable by superiors" do
    user_slave = Factory.create(:User)
    user_master = Factory.create(:User)
    guild = Factory.create(:Guild)
    user_master.assignments << Factory.create(:Assignment,{:guild_id => guild.id, :role => 'Leader'})
    user_slave.assignments << Factory.create(:Assignment,{:guild_id => guild.id, :role => 'Member'})
    user_slave.kickable_by?(user_master,guild).should == true
    user_slave.demoteable_by?(user_master,guild).should == true
    user_slave.promoteable_by?(user_master,guild).should == true
  end
  
  it "shouldn't be kickable by themself if it's the only leader" do
    user_master = Factory.create(:User)
    guild = Factory.create(:Guild)
    user_master.assignments << Factory.create(:Assignment,{:guild_id => guild.id, :role => 'Leader'})
    user_master.kickable_by?(user_master,guild).should == false
    user_master.demoteable_by?(user_master,guild).should == false
  end
end
