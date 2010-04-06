require 'spec_helper'

describe RemoteQuery do
  before(:each) do
    @valid_attributes = {
      :priority => 1,
      :efford => 1,
      :action => "value for action",
      :character_id => 1,
      :guild_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    RemoteQuery.create!(@valid_attributes)
  end
end
