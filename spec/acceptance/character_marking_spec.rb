require File.dirname(__FILE__) + '/acceptance_helper'

feature "Character Marking" do
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
    log_in_with user
    user.assignments << Factory.create(:Assignment,:role => "member", :guild_id => guild.id)
    guild.characters << char
  end
  
  it "should be able to mark a charater" do
    visit "/characters/#{char.id}"
    click_link "Link"
    page.should have_css(".notice")
    char.reload
    char.user.should == user
  end
  
  it "should be able to unmark his/her charater" do
    char.update_attribute(:user_id, user.id)
    visit "/characters/#{char.id}"
    click_link "Unlink"
    page.should have_css(".notice")
    char.reload
    char.user.should_not == user
  end
end
