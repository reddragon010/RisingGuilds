require 'spec_helper'

describe Guild do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :officer_rank => 1,
      :raidleader_rank => 1,
      :ail => 1,
      :activity => 1,
      :growth => 1,
      :altratio => 1,
      :classratio => 1,
      :achivementpoints => 1,
      :ration => 1,
      :token => "value for token",
      :website => "value for website",
      :description => "value for description"
    }
  end

  it "should create a new instance given valid attributes" do
    Guild.create!(@valid_attributes)
  end
end
