def user(login="user")
  @user ||= Factory(:User, :login => login)
end

def login(username="user",password="password")
  user
  visit path_to("the homepage")
  page.should have_content("Login")
  click_link "Login"
  fill_in "user_session_login", :with => username 
  fill_in "user_session_password", :with => password
  click_button "Login"
end

Given /^I am a registered user$/ do
  user
end

When /^I login$/ do
  login
end

Given /^I am logged in$/ do
  login
end

Given /^I am logged out$/ do
  visit logout_path
end

When /^I login as "([^\"]*)" with password "([^\"]*)"$/ do |username, password|
  unless username.blank?
    login(username,password)
  end
end

Then /^I should be on ([^\"]*)$/ do |page_name| #"
  response.request.path.should == path_to(page_name)
end

Then /^I should see my account$/ do
  page.should have_content(@user.login)
end

Given /^I am a "([^\"]*)"$/ do |role|
  r = Role.create(:name => role)
  @user.assignments << Assignment.create(:guild_id => @guild.id, :role_id => r.id)
  @user.save
end

When /^I join the guild with a valid token$/ do
  visit "guilds/#{@guild.id}/join/#{@guild.token}"
end

When /^I join the guild with a invalid token$/ do
  visit "guilds/#{@guild.id}/join/#{@guild.token + "invalid"}"
end


Then /^I should be a member of the guild$/ do
  @guild.users.first.login.should == @user.login
end

Then /^I should not be a member of the guild$/ do
  @guild.users.empty?.should == true
end

