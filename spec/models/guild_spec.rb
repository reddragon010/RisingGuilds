require 'spec_helper'

describe Guild do
  before(:each) do
  end

  it "should create a new instance given valid attributes" do
    Factory.create(:guild)
  end
  
  it "should know its characters" do
    @guild = Factory.create(:guild)
    @characters = [Factory.create(:character),Factory.create(:character)]
    @guild.Characters << @characters
    @guild.Characters.count.should == 2
  end
  
  it "shouldn't accept a description with lesser then 100 Characters" do
    @guild = Factory.build(:guild, :description => "Too short man!!")
    @guild.valid?.should be_false
    @guild.should have_at_least(1).error_on(:description)
  end
  
  it "should not be valid without a name" do
    @guild = Factory.build(:guild, :name => "")
    @guild.valid?.should be_false
    @guild.should have_at_least(1).error_on(:name)
  end
  
  it "should not be valid without a token" do
    @guild = Factory.build(:guild, :token => "")
    @guild.valid?.should be_false
    @guild.should have_at_least(1).error_on(:token)
  end
end
