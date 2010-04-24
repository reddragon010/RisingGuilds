Given /^I got an apikey$/ do
  @apikey = @user.single_access_token
end

Given /^I got an wrong apikey$/ do
  @apikey = "wrongkey"
end

Given /^a guild named "([^\"]*)"$/ do |name|
    @guild ||= Factory(:Guild, :name => name)
end
