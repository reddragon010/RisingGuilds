require File.dirname(__FILE__) + '/acceptance_helper'

feature "Reset Password" do
  let :user do
    Factory :User
  end
  
  let :guild do
    Factory :Guild
  end
  
  scenario "get a lost password" do
    visit "/login"
    fill_in "user_session_login", :with => user.login
    fill_in "user_session_password", :with => "password"
    click_button "Login"
    click_link "Logout"
    old_password = user.password
    token = user.perishable_token
    user.update_attribute(:perishable_token, token)
    visit "/password_resets/#{user.perishable_token}/edit"
    page.should have_content("Change My Password")
    fill_in "user_password", :with => "password2"
    fill_in "user_password_confirmation", :with => "password2"
    click_button "user_submit"
    should_have_notice "Password was successfully updated."
    user.crypted_password.should_not == old_password
  end
end