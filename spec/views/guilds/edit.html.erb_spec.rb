require 'spec_helper'

describe "/guilds/edit.html.erb" do
  include GuildsHelper

  before(:each) do
    assigns[:guild] = @guild = stub_model(Guild,
      :new_record? => false,
      :name => "value for name",
      :officer_rank => 1,
      :raidleader_rank => 1,
      :ail => 1,
      :activity => 1,
      :growth => 1,
      :altratio => 1,
      :classratio => 1,
      :achivementpoints => 1,
      :ration => 1,
      :token => "value for token",
      :website => "value for website",
      :description => "value for description"
    )
  end

  it "renders the edit guild form" do
    render

    response.should have_tag("form[action=#{guild_path(@guild)}][method=post]") do
      with_tag('input#guild_name[name=?]', "guild[name]")
      with_tag('input#guild_officer_rank[name=?]', "guild[officer_rank]")
      with_tag('input#guild_raidleader_rank[name=?]', "guild[raidleader_rank]")
      with_tag('input#guild_ail[name=?]', "guild[ail]")
      with_tag('input#guild_activity[name=?]', "guild[activity]")
      with_tag('input#guild_growth[name=?]', "guild[growth]")
      with_tag('input#guild_altratio[name=?]', "guild[altratio]")
      with_tag('input#guild_classratio[name=?]', "guild[classratio]")
      with_tag('input#guild_achivementpoints[name=?]', "guild[achivementpoints]")
      with_tag('input#guild_ration[name=?]', "guild[ration]")
      with_tag('input#guild_token[name=?]', "guild[token]")
      with_tag('input#guild_website[name=?]', "guild[website]")
      with_tag('textarea#guild_description[name=?]', "guild[description]")
    end
  end
end
