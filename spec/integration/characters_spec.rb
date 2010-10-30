require 'spec_helper'

describe "Characters" do
  fixtures :roles
  
  before(:each) do
    @guild = Guild.first || Factory(:Guild)
    (1..5).each do 
      @guild.characters << Factory(:Character)
    end 
    visit root_path 
  end
  
  context "a member" do
    before(:each) do
      login
      assing_user_to_guild_as("member")
    end
    
    it "should be able to mark a charater" do
      @char = Character.first
      visit character_path(@char)
      click_link_or_button "Mark as Mine!"
      page.should have_css(".notice")
      @char.reload
      @char.user.should == @user
    end
    
    it "should be able to unmark his/her charater" do
      @char = Character.first
      @char.update_attribute(:user_id, @user.id)
      visit character_path(@char)
      click_link_or_button "Not Mine!"
      page.should have_css(".notice")
      @char.reload
      @char.user.should_not == @user
    end
  end
end
