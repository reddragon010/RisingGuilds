require 'spec_helper'

describe "/events/show.html.erb" do
  include EventsHelper
  before(:each) do
    assigns[:event] = @event = stub_model(Event,
      :action => "value for action",
      :content => "value for content",
      :guild_id => 1,
      :character_id => 1
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ action/)
    response.should have_text(/value\ for\ content/)
    response.should have_text(/1/)
    response.should have_text(/1/)
  end
end
