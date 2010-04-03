require 'spec_helper'

describe Character do
  before(:each) do
    @valid_attributes = {
      :guild_id => 1,
      :user_id => 1,
      :name => "value for name",
      :rank => 1,
      :level => 1,
      :online => false,
      :last_seen => Time.now,
      :activity => 1,
      :class_id => 1,
      :race_id => 1,
      :faction_id => 1,
      :gender_id => 1,
      :achivementpoints => 1,
      :ail => 1,
      :talentspec1 => "value for talentspec1",
      :talentspec2 => "value for talentspec2",
      :profession1 => "value for profession1",
      :profession2 => "value for profession2",
      :main => false
    }
  end

  it "should create a new instance given valid attributes" do
    Character.create!(@valid_attributes)
  end
end
