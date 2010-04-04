require 'spec_helper'

describe "/events/index.html.erb" do
  include EventsHelper

  before(:each) do
    assigns[:events] = [
      stub_model(Event,
        :action => "value for action",
        :content => "value for content",
        :guild_id => 1,
        :character_id => 1
      ),
      stub_model(Event,
        :action => "value for action",
        :content => "value for content",
        :guild_id => 1,
        :character_id => 1
      )
    ]
  end

  it "renders a list of events" do
    render
    response.should have_tag("tr>td", "value for action".to_s, 2)
    response.should have_tag("tr>td", "value for content".to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
  end
end
