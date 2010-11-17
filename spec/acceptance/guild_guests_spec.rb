require File.dirname(__FILE__) + '/acceptance_helper'

feature "Guild Guests" do
  
  let :guild do
    Factory :Guild
  end
  
  scenario "Scenario name" do
    true.should == true
  end
  
  scenario "guest should be able to visit the guildpage" do
    visit "/guilds/#{guild.id}"
    page.status_code.should == 200 
  end
  
  scenario "guest shouldn't be able to create a guild" do
    visit "/guilds/#{guild.id}"
    visit "/guilds/new"
    should_not_be_on "/guilds/new"
    page.should have_css(".error")
  end
  
  scenario "guest shouldn't be able to sync a guild" do
    visit "guilds/#{guild.id}/actualize"
    should_not_be_on "guilds/#{guild.id}/actualize"
    Delayed::Job.all.count.should == 0
  end
  
  scenario "guest shouldn't be able to edit a guild" do
    visit "/guilds/#{guild.id}/edit"
    should_not_be_on "/guilds/#{guild.id}/edit"
    page.should have_css(".error")
  end
  
  
end
