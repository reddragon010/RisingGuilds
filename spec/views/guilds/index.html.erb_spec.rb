require 'spec_helper'

describe "/guilds/index.html.erb" do
  include GuildsHelper

  before(:each) do
    assigns[:guilds] = [
      stub_model(Guild,
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
      ),
      stub_model(Guild,
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
    ]
  end

  it "renders a list of guilds" do
    render
    response.should have_tag("tr>td", "value for name".to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", "value for token".to_s, 2)
    response.should have_tag("tr>td", "value for website".to_s, 2)
    response.should have_tag("tr>td", "value for description".to_s, 2)
  end
end
