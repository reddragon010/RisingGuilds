Given /^a raid$/ do
  @raid ||= Factory(:Raid, :guild_id => @guild.id)
  @raid.guilds << @guild
end

Given /^I am linked to a character$/ do
  
  @guild.characters.first.update_attribute(:user_id, @user.id)
  @user.reload
  @user.characters.count.should == 1
end