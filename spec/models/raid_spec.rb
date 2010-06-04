require 'spec_helper'

describe Raid do
  before(:each) do
    @valid_attributes = {
      :guild_id => 1,
      :title => "value for title",
      :max_attendees => 1,
      :date => Time.now,
      :invite_start => Time.now + 1.hour,
      :start => Time.now + 2.hour,
      :end => Time.now + 3.hour,
      :description => "value for description",
      :leader => 1,
      :closed => false
    }
  end

  it "should create a new instance given valid attributes" do
    Raid.create!(@valid_attributes)
  end
end
