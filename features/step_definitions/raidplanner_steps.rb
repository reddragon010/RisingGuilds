Given /^a raid$/ do
  @raid ||= Factory(:Raid, :guild_id => @guild.id)
end
