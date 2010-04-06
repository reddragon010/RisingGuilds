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
    @guild.Characters << @characters
    @guild.Characters.count.should == 2
  end
  
  it "should can get some RemoteQueries" do
    @guild = Factory.create(:Guild)
    @remotequeries = [Factory.create(:RemoteQuery),Factory.create(:RemoteQuery)]
    @guild.RemoteQueries << @remotequeries
    @guild.RemoteQueries.count.should == 2
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
end
