Given /^a raid$/ do
  @raid ||= Factory(:Raid, :guild_id => @guild.id)
  @raid.guilds << @guild
end

Given /^I am linked to a character$/ do
  @character = @guild.characters.first
  @character.update_attribute(:user_id, @user.id)
  @user.reload
  @user.characters.count.should == 1
end

When /^I select my character from "([^\"]*)"$/ do |field|
  select(@character.name, :from => field)
end

