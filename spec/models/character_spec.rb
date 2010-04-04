require 'spec_helper'

describe Character do
  before(:each) do
  end

  it "should create a new instance given valid attributes" do
    Factory.create(:character)
  end
  
  it "should can linked to a guild" do
    @guild = Factory.create(:guild)
    @character = Factory.create(:character)
    @character.Guild = @guild
    @character.Guild.name.should == @guild.name
  end
end
