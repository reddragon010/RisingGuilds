Given /^a public newsentry$/ do
  Factory(:Newsentry, :public => true, :guild_id => @guild.id, :title => "PublicTestEntry")
end

Given /^a private newsentry$/ do
  Factory(:Newsentry, :public => false, :guild_id => @guild.id, :title => "PrivateTestEntry")
end
