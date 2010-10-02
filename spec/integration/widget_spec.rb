require 'spec_helper'  

describe WidgetController do
  fixtures :roles
  
  before(:each) do
    @guild = Guild.first || Factory(:Guild) 
    visit root_path 
  end  
  
  context "a member" do
    before(:each) do
      login
      assing_user_to_guild_as("member")
    end
    
    it "should not get access with a invalid key" do
      visit "/widget/onlinemembers/#{@guild.id}/#{@user.single_access_token}invalid"
      page.should have_content("Invalid API Key")
    end
    
    it "should get access with a valid key" do
      visit "/widget/onlinemembers/#{@guild.id}/#{@user.single_access_token}"
      page.should have_content("document.write(")
    end
  end
end