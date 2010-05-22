require 'spec_helper'

describe Raid do
  before(:each) do
    @valid_attributes = {
      :guild_id => 1,
      :title => "value for title",
      :max_attendees => 1,
      :invite_start => Time.now,
      :start => Time.now,
      :end => Time.now,
      :description => "value for description",
      :leader => 1,
      :closed => false
    }
  end

  it "should create a new instance given valid attributes" do
    Raid.create!(@valid_attributes)
  end
end
