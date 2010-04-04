require 'spec_helper'

describe "/events/new.html.erb" do
  include EventsHelper

  before(:each) do
    assigns[:event] = stub_model(Event,
      :new_record? => true,
      :action => "value for action",
      :content => "value for content",
      :guild_id => 1,
      :character_id => 1
    )
  end

  it "renders new event form" do
    render

    response.should have_tag("form[action=?][method=post]", events_path) do
      with_tag("input#event_action[name=?]", "event[action]")
      with_tag("input#event_content[name=?]", "event[content]")
      with_tag("input#event_guild_id[name=?]", "event[guild_id]")
      with_tag("input#event_character_id[name=?]", "event[character_id]")
    end
  end
end
