require 'spec_helper'

describe Guild do
  before(:each) do
  end

  it "should create a new instance given valid attributes" do
    Factory.create(:guild)
  end
  
  it "should know its characters" do
    @guild = Factory.create(:guild, :name => "RSpecBoons")
    @characters = [Factory.create(:character),Factory.create(:character)]
    @guild.Characters << @characters
    @guild.Characters.count.should == 2
  end
end
