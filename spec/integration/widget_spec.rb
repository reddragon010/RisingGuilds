require 'spec_helper'  

describe WidgetsController do
  fixtures :roles
  
  before(:each) do
    @guild = Guild.first || Factory(:Guild)
    @character = Factory.create(:Character, :online => true, :guild_id => @guild.id)
    visit root_path 
  end  
  
  context "a guest" do
    it "should see the onlinemembers in json" do
      visit "guilds/#{@guild.id}/onlinemembers?callback=wio_callback"
      page.should have_content(@character.name)
      page.should have_content('wio_callback')
    end
  end
end