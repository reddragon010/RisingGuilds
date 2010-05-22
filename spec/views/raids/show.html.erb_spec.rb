require 'spec_helper'

describe "/raids/show.html.erb" do
  include RaidsHelper
  before(:each) do
    assigns[:raid] = @raid = stub_model(Raid,
      :guild_id => 1,
      :title => "value for title",
      :max_attendees => 1,
      :description => "value for description",
      :leader => 1,
      :closed => false
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/1/)
    response.should have_text(/value\ for\ title/)
    response.should have_text(/1/)
    response.should have_text(/value\ for\ description/)
    response.should have_text(/1/)
    response.should have_text(/false/)
  end
end
