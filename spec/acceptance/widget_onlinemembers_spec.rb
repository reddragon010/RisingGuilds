require File.dirname(__FILE__) + '/acceptance_helper'

feature "Widget Onlinemembers" do
  
  let :guild do
    Factory :Guild
  end
  
  scenario "should see the onlinemembers in json" do
    char = Factory.create(:Character, :online => true, :guild_id => guild.id)
    visit "guilds/#{guild.id}/onlinemembers?callback=wio_callback"
    page.should have_content(char.name)
    page.should have_content('wio_callback')
  end
end
