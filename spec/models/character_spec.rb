require 'spec_helper'

describe Character do
  before(:each) do
  end

  it "should create a new instance given valid attributes" do
    Factory.create(:Character)
  end
  
  it "should can be linked to a guild" do
    @guild = Factory.create(:Guild)
    @character = Factory.create(:Character)
    @character.Guild = @guild
    @character.Guild.name.should == @guild.name
  end
end
