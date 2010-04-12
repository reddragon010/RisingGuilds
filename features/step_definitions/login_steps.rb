Given /^a user "([^\"]*)"$/ do |username|
  Factory.create(:user,:login => username)
end

Given /^I'am logged out$/ do
  visit logout_path
end

When /^I login as "([^\"]*)" with password "([^\"]*)"$/ do |username, password|
  unless username.blank?
    fill_in "Login", :with => username
    fill_in "Password", :with => password
    click_button "Login"
  end
end

Then /^I should be on ([^\"]*)$/ do |page_name|
  response.request.path.should == path_to(page_name)
end
