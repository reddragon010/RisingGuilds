module ControllerMacros  
  def login
    @user = Factory(:User)
    visit login_path
    fill_in 'Login', :with => @user.login
    fill_in 'Password', :with => 'password'
    click 'Login'
    page.should have_css(".notice")
  end
  
  def assing_user_to_guild_as(role)
    role_id = Role.where(:name => role).first.id
    @guild.assignments << Assignment.new(:role_id => role_id, :user_id => @user.id, :guild_id => @guild.id)
  end
end