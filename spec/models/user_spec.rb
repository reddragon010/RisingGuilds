require 'spec_helper'

describe User do
  before(:each) do
    
  end

  it "should create a new instance given valid attributes" do
    Factory(:User)
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
end
