require File.dirname(__FILE__) + '/acceptance_helper'

feature "Newsentries" do

  let :guild do
    Factory :Guild
  end
  
  let :user do
    Factory :User
  end
  
  before(:each) do
    log_in_with user
  end
  
  before(:each) do
    @ne_public = Factory(:Newsentry, :public => true, :guild_id => guild.id, :title => "PublicTestEntry")
    @ne_private = Factory(:Newsentry, :public => false, :guild_id => guild.id, :title => "PrivateTestEntry") 
    visit "/"
    log_in_with user
  end
  
    
    it "should see public newsentries but no private ones" do
      visit "/guilds/#{guild.id}"
      page.should have_content(@ne_public.title)
      page.should_not have_content(@ne_private.title)
    end
    
    
    it "should see public and private newsentries" do
      user.assignments << Factory.build(:Assignment, :guild_id => guild.id, :role => 'member')
      visit "/guilds/#{guild.id}"
      page.should have_content(@ne_public.title)
      page.should have_content(@ne_private.title)
    end
end
