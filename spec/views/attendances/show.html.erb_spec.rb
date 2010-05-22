require 'spec_helper'

describe "/attendances/show.html.erb" do
  include AttendancesHelper
  before(:each) do
    assigns[:attendance] = @attendance = stub_model(Attendance,
      :character_id => 1,
      :raid_id => 1,
      :role => "value for role",
      :status => 1,
      :message => 
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/value\ for\ role/)
    response.should have_text(/1/)
    response.should have_text(//)
  end
end
