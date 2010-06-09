Given /^the guild have some members$/ do
  (1..10).each do
    @guild.characters << Factory(:Character)
  end
  @guild.save
end