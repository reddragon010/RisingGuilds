module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name
    
    when /the home\s?page/
      '/'
    when /the login page/
      login_path
    when /the logout page/
      logout_path
    when /the signup page/
      signup_path
    when /my account/
      account_path
    when /the guildpage/
      guild_path @guild
    when /the guildmembers-page/
      guild_characters_path @guild
    when /a new guild/
      new_guild_path
    when /actualize guild/
      "/guilds/#{@guild.id}/actualize"
    when /edit guild/
      edit_guild_path @guild
    when /^(.*)´s onlinemembers-widget/
      "/widget/onlinemembers/#{Guild.find_by_name($1).id}/#{@apikey}"
    
    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
