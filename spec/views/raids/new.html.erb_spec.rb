require 'spec_helper'

describe "/raids/new.html.erb" do
  include RaidsHelper

  before(:each) do
    assigns[:raid] = stub_model(Raid,
      :new_record? => true,
      :guild_id => 1,
      :title => "value for title",
      :max_attendees => 1,
      :description => "value for description",
      :leader => 1,
      :closed => false
    )
  end

  it "renders new raid form" do
    render

    response.should have_tag("form[action=?][method=post]", raids_path) do
      with_tag("input#raid_guild_id[name=?]", "raid[guild_id]")
      with_tag("input#raid_title[name=?]", "raid[title]")
      with_tag("input#raid_max_attendees[name=?]", "raid[max_attendees]")
      with_tag("textarea#raid_description[name=?]", "raid[description]")
      with_tag("input#raid_leader[name=?]", "raid[leader]")
      with_tag("input#raid_closed[name=?]", "raid[closed]")
    end
  end
end
