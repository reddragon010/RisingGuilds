require 'spec_helper'

describe "/guilds/show.html.erb" do
  include GuildsHelper
  before(:each) do
    assigns[:guild] = @guild = stub_model(Guild,
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

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ name/)
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/value\ for\ token/)
    response.should have_text(/value\ for\ website/)
    response.should have_text(/value\ for\ description/)
  end
end
