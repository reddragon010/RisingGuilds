require 'spec_helper'

describe Event do
  before(:each) do
    @valid_attributes = {
      :action => "value for action",
      :content => "value for content",
      :guild_id => 1,
      :character_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Event.create!(@valid_attributes)
  end
end
