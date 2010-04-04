require 'spec_helper'

describe "/events/edit.html.erb" do
  include EventsHelper

  before(:each) do
    assigns[:event] = @event = stub_model(Event,
      :new_record? => false,
      :action => "value for action",
      :content => "value for content",
      :guild_id => 1,
      :character_id => 1
    )
  end

  it "renders the edit event form" do
    render

    response.should have_tag("form[action=#{event_path(@event)}][method=post]") do
      with_tag('input#event_action[name=?]', "event[action]")
      with_tag('input#event_content[name=?]', "event[content]")
      with_tag('input#event_guild_id[name=?]', "event[guild_id]")
      with_tag('input#event_character_id[name=?]', "event[character_id]")
    end
  end
end
