require 'spec_helper'

describe "/raids/index.html.erb" do
  include RaidsHelper

  before(:each) do
    assigns[:raids] = [
      stub_model(Raid,
        :guild_id => 1,
        :title => "value for title",
        :max_attendees => 1,
        :description => "value for description",
        :leader => 1,
        :closed => false
      ),
      stub_model(Raid,
        :guild_id => 1,
        :title => "value for title",
        :max_attendees => 1,
        :description => "value for description",
        :leader => 1,
        :closed => false
      )
    ]
  end

  it "renders a list of raids" do
    render
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", "value for title".to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", "value for description".to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", false.to_s, 2)
  end
end
