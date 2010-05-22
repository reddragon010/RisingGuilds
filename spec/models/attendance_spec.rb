require 'spec_helper'

describe Attendance do
  before(:each) do
    @valid_attributes = {
      :character_id => 1,
      :raid_id => 1,
      :role => "value for role",
      :status => 1,
      :message => 
    }
  end

  it "should create a new instance given valid attributes" do
    Attendance.create!(@valid_attributes)
  end
end
