describe NewsentriesController do
  fixtures :roles
  
  before(:each) do
    @guild = Guild.first || Factory(:Guild)
    @ne_public = Factory(:Newsentry, :public => true, :guild_id => @guild.id, :title => "PublicTestEntry")
    @ne_private = Factory(:Newsentry, :public => false, :guild_id => @guild.id, :title => "PrivateTestEntry") 
    visit root_path 
  end
  
  context "a user" do
    before(:each) do
      login
    end
    
    it "should see public newsentries but no private ones" do
      visit guild_path(@guild)
      page.should have_content(@ne_public.title)
      page.should_not have_content(@ne_private.title)
    end
  end
  
  context "a member" do
    before(:each) do
      login
      assing_user_to_guild_as("member")
    end
    
    it "should see public and private newsentries" do
      visit guild_path(@guild)
      page.should have_content(@ne_public.title)
      page.should have_content(@ne_private.title)
    end
  end
end