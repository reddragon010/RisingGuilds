require File.dirname(__FILE__) + '/acceptance_helper'

feature "Guild Users" do
  
  let :guild do
    Factory :Guild
  end
  
  let :user do
    Factory :User
  end
  
  before(:each) do
    log_in_with user
  end
  
  scenario "should be able to visit the guildpage" do
    visit "/guilds/#{guild.id}"
    page.status_code.should == 200
  end
  
  scenario "should be able to create a guild" do
    visit "/guilds/new"
    current_path.should == "/guilds/new"
    fill_in "guild_name", :with => "Divine"
    fill_in "guild_website", :with => "http://divine.dreamblaze.net"
    fill_in "guild_description", :with => "Bla Bla Bla Bla Bla Bla Bla"
    click_button "guild_submit"
    page.should have_css(".notice")
  end
  
  #scenario "should be able to join a guild with a valid token" do
  #  visit "guilds/#{guild.id}/join/#{guild.token}"
  #  puts page.body
  #  guild.reload.members.include?(user.login).should be_true
  #  page.should have_css(".notice")
  #end
  
  #scenario "shouldn't be able to join a guild with a invalid token" do
  #  visit "guilds/#{guild.id}/join/#{guild.token+"invalid"}"
  #  guild.reload.members.include?(user.login).should be_false
  #  page.should have_css(".error")
  #end
end