require File.dirname(__FILE__) + '/acceptance_helper'

feature "Guild Leaders" do
  
  let :guild do
    Factory :Guild
  end
  
  let :user do
    Factory :User
  end
  
  let :char do
    Factory :Character
  end
  
  before(:each) do
    user.assignments << Factory.create(:Assignment,:role => "leader", :guild_id => guild.id)
    log_in_with user
    should_have_notice "Login successful!"    
  end
    
  it "should be able to sync the guild" do
    visit "guilds/#{guild.id}/actualize"
    page.should have_css(".notice")
    Delayed::Job.all.count.should == 1
  end
    
  it "should be able to edit the guild" do
    visit "/guilds/#{guild.id}/edit"
    should_be_on "/guilds/#{guild.id}/edit"
    fill_in "guild_website", :with => "http://justworked.net"
    click_button "update"
    should_be_on "/guilds/#{guild.id}"
    page.should have_css(".notice")
    page.should have_content("http://justworked.net")
  end
end
