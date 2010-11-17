module HelperMethods
  # Put helper methods you need to be available in all tests here.
  
  def log_in_with(user)
    visit '/login'
    fill_in "Login",     :with => user.login
    fill_in "Password", :with => "password"
    click_link_or_button "Login"
  end
  
  def should_have_error(message=nil)
    if message.nil?
      page.should have_css("#flash.error", :text => message)
    else
      page.should have_css("#flash.error")
    end
  end
  
  def should_have_notice(message=nil)
    if message.nil?
      page.should have_css("#flash.notice", :text => message)
    else
      page.should have_css("#flash.notice")
    end
  end
  
  def should_have_flash
      page.should have_css("#flash")
  end
  
  def should_be_on(path)
    page.current_url.should match(Regexp.new(path))
  end

  def should_not_be_on(path)
    page.current_url.should_not match(Regexp.new(path))
  end
  
  def fill_the_following(fields={})
    fields.each do |field, value|
      fill_in field,  :with => value
    end
  end
  
  def should_have_the_following(*contents)
    contents.each do |content|
      page.should have_content(content)
    end
  end
  
  def should_have_table(table_name, *rows)
    within(table_name) do
      rows.each do |columns|
        columns.each { |content| page.should have_content(content) }
      end
    end
  end
end

RSpec.configuration.include HelperMethods, :type => :acceptance
