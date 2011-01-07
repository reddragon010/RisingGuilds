require File.dirname(__FILE__) + '/acceptance_helper'

feature "Registration" do
  
  let :user do
    Factory :User
  end

  let :invalid_user do
    mock 'User', :login => "jonhdoe"
  end
  
  scenario "Register new user" do
    visit "/signup"
    fill_in 'Login', :with => 'test123'
    fill_in 'Email', :with => 'test123@test.com'
    click_button 'Register'
    should_be_on "/"
    visit "/register/#{User.find_by_login('test123').perishable_token}"
    fill_in 'Set your password', :with => 'password'
    fill_in 'Password confirmation', :with => 'password'
    click_button 'Activate'
    should_have_notice 'Your account has been activated.'
    should_be_on "/account"
    User.find_by_login("test123").active?.should be_true
  end
  
  scenario "Login as invalid user" do
    log_in_with invalid_user
    should_have_error "Login or Password incorrect!"
  end
  
  scenario "Login and Logout" do
    log_in_with user
    should_have_notice "Login successful!"
    visit "/logout"
    should_have_notice "Logout successful!"
  end
end
