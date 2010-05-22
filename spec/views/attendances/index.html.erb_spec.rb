require 'spec_helper'

describe "/attendances/index.html.erb" do
  include AttendancesHelper

  before(:each) do
    assigns[:attendances] = [
      stub_model(Attendance,
        :character_id => 1,
        :raid_id => 1,
        :role => "value for role",
        :status => 1,
        :message => 
      ),
      stub_model(Attendance,
        :character_id => 1,
        :raid_id => 1,
        :role => "value for role",
        :status => 1,
        :message => 
      )
    ]
  end

  it "renders a list of attendances" do
    render
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", "value for role".to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", .to_s, 2)
  end
end
