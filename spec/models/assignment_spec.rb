require 'spec_helper'

describe Assignment do
  before(:each) do
    
  end

  it "should create a new instance given valid attributes" do
    a = Factory(:Assignment)
    a.valid?.should be_true
  end
end
