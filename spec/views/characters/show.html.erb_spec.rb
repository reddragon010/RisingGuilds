require 'spec_helper'

describe "/characters/show.html.erb" do
  include CharactersHelper
  before(:each) do
    assigns[:character] = @character = stub_model(Character,
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

  it "renders attributes in <p>" do
    render
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/value\ for\ name/)
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/false/)
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/value\ for\ talentspec1/)
    response.should have_text(/value\ for\ talentspec2/)
    response.should have_text(/value\ for\ profession1/)
    response.should have_text(/value\ for\ profession2/)
    response.should have_text(/false/)
  end
end
