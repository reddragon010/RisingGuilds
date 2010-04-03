require 'spec_helper'

describe "/characters/index.html.erb" do
  include CharactersHelper

  before(:each) do
    assigns[:characters] = [
      stub_model(Character,
        :guild_id => 1,
        :user_id => 1,
        :name => "value for name",
        :rank => 1,
        :level => 1,
        :online => false,
        :activity => 1,
        :class_id => 1,
        :race_id => 1,
        :faction_id => 1,
        :gender_id => 1,
        :achivementpoints => 1,
        :ail => 1,
        :talentspec1 => "value for talentspec1",
        :talentspec2 => "value for talentspec2",
        :profession1 => "value for profession1",
        :profession2 => "value for profession2",
        :main => false
      ),
      stub_model(Character,
        :guild_id => 1,
        :user_id => 1,
        :name => "value for name",
        :rank => 1,
        :level => 1,
        :online => false,
        :activity => 1,
        :class_id => 1,
        :race_id => 1,
        :faction_id => 1,
        :gender_id => 1,
        :achivementpoints => 1,
        :ail => 1,
        :talentspec1 => "value for talentspec1",
        :talentspec2 => "value for talentspec2",
        :profession1 => "value for profession1",
        :profession2 => "value for profession2",
        :main => false
      )
    ]
  end

  it "renders a list of characters" do
    render
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", "value for name".to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", false.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", "value for talentspec1".to_s, 2)
    response.should have_tag("tr>td", "value for talentspec2".to_s, 2)
    response.should have_tag("tr>td", "value for profession1".to_s, 2)
    response.should have_tag("tr>td", "value for profession2".to_s, 2)
    response.should have_tag("tr>td", false.to_s, 2)
  end
end
