require 'spec_helper'

describe GuildsController do
  fixtures :roles
  
  before(:each) do
    @guild = Guild.first || Factory(:Guild) 
    visit root_path 
  end
  
  context "a guest" do
    it "should be able to visit the guildpage" do
      visit guild_path(@guild)
      page.status_code.should == 200 
    end
    
    it "shouldn't be able to create a guild" do
      visit new_guild_path
      current_path.should == root_path
      page.should have_css(".error")
    end
    
    it "shouldn't be able to sync a guild" do
      visit "guilds/#{@guild.id}/actualize"
      current_path.should == root_path
      Delayed::Job.all.count.should == 1
    end
    
    it "shouldn't be able to edit a guild" do
      visit edit_guild_path(@guild)
      current_path.should == root_path
      page.should have_css(".error")
    end  
  end
  
  context "a user" do
    before(:each) do
      login
    end
    
    it "should be able to visit the guildpage" do
      visit guild_path(@guild)
      page.status_code.should == 200
    end
     
    it "should be able to create a guild" do
      visit new_guild_path
      current_path.should == new_guild_path
      fill_in "guild_name", :with => "Divine"
      fill_in "guild_website", :with => "http://divine.dreamblaze.net"
      fill_in "guild_description", :with => "Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla "
      click_link_or_button "guild_submit"
      page.should have_css(".notice")
    end
    
    it "should be able to join a guild with a valid token" do
      visit "guilds/#{@guild.id}/join/#{@guild.token}"
      @guild.members.include?(@user.login).should be_true
      page.should have_css(".notice")
    end
    
    it "shouldn't be able to join a guild with a invalid token" do
      visit "guilds/#{@guild.id}/join/#{@guild.token+"invalid"}"
      @guild.members.include?(@user.login).should be_false
      page.should have_css(".error")
    end
  end
  
  context "a member" do
    before(:each) do
      login
      assing_user_to_guild_as("member")
    end
    
    it "should be able to visit the guildpage" do
      visit guild_path(@guild)
      page.status_code.should == 200
    end
  end
  
  context "a leader" do
    before(:each) do
      login
      assing_user_to_guild_as("leader")
    end
    
    it "should be able to sync the guild" do
      visit "guilds/#{@guild.id}/actualize"
      page.should have_css(".notice")
      Delayed::Job.all.count.should == 1
    end
    
    it "should be able to edit the guild" do
      visit edit_guild_path(@guild)
      current_path.should == edit_guild_path(@guild)
      fill_in "guild_website", :with => "http://justworked.net"
      click_link_or_button "update"
      current_path.should == guild_path(@guild)
      page.should have_css(".notice")
      page.should have_content("http://justworked.net")
    end
  end
end
