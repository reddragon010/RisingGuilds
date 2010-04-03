require 'spec_helper'

describe "/characters/new.html.erb" do
  include CharactersHelper

  before(:each) do
    assigns[:character] = stub_model(Character,
      :new_record? => true,
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
  end

  it "renders new character form" do
    render

    response.should have_tag("form[action=?][method=post]", characters_path) do
      with_tag("input#character_guild_id[name=?]", "character[guild_id]")
      with_tag("input#character_user_id[name=?]", "character[user_id]")
      with_tag("input#character_name[name=?]", "character[name]")
      with_tag("input#character_rank[name=?]", "character[rank]")
      with_tag("input#character_level[name=?]", "character[level]")
      with_tag("input#character_online[name=?]", "character[online]")
      with_tag("input#character_activity[name=?]", "character[activity]")
      with_tag("input#character_class_id[name=?]", "character[class_id]")
      with_tag("input#character_race_id[name=?]", "character[race_id]")
      with_tag("input#character_faction_id[name=?]", "character[faction_id]")
      with_tag("input#character_gender_id[name=?]", "character[gender_id]")
      with_tag("input#character_achivementpoints[name=?]", "character[achivementpoints]")
      with_tag("input#character_ail[name=?]", "character[ail]")
      with_tag("input#character_talentspec1[name=?]", "character[talentspec1]")
      with_tag("input#character_talentspec2[name=?]", "character[talentspec2]")
      with_tag("input#character_profession1[name=?]", "character[profession1]")
      with_tag("input#character_profession2[name=?]", "character[profession2]")
      with_tag("input#character_main[name=?]", "character[main]")
    end
  end
end
