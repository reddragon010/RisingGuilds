When /^fill in some guildinfos$/ do
  fill_in "name", :with => "Divine"
  fill_in "description", :with => "Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla "
end

Given /^a guild$/ do
  @guild ||= Factory(:Guild)
end

Given /^I am a "([^\"]*)" of the guild/ do |role|
  role_id = Role.find_by_name(role).id
  @guild.assignments << Assignment.new(:role_id => role_id, :user_id => @user.id, :guild_id => @guild.id)
end

Given /^there is a role named "([^\"]*)"$/ do |role_name|
  Factory(:Role, :name => role_name)
end
