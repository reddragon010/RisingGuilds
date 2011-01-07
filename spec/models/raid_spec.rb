require 'spec_helper'

describe Raid do
  before(:each) do
  end

  it "should create a new instance given valid attributes" do
    Factory(:Raid).valid?.should be_true
  end
  
  it "should validate that the invite_time could only be in the future" do
    @raid = Factory.build(:Raid, :invite_start => Time.now - 1.hour)
    @raid.valid?.should be_false
    @raid.should have_at_least(1).error_on(:invite_start)
  end
  
  it "should validate that the invite_time could only be in the future" do
    @raid = Factory.build(:Raid, :start => Time.now - 1.hour)
    @raid.valid?.should be_false
    @raid.should have_at_least(1).error_on(:start)
  end
  
  it "should validate that the invite_time could only be in the future" do
    @raid = Factory.build(:Raid, :end => Time.now - 1.hour)
    @raid.valid?.should be_false
    @raid.should have_at_least(1).error_on(:end)
  end
  
  it "should validate that the invite_time happens befor start" do
    @raid = Factory.build(:Raid, :start => Time.now + 1.hour, :invite_start => Time.now + 2.hours)
    @raid.valid?.should be_false
    @raid.should have_at_least(1).error_on(:invite_start)
  end
  
  it "should validate that the end happens after start" do
    @raid = Factory.build(:Raid, :start => Time.now + 2.hour, :end => Time.now + 1.hours)
    @raid.valid?.should be_false
    @raid.should have_at_least(1).error_on(:end)
  end
  
end
