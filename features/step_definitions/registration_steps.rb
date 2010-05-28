Then /^I should receive an activation email$/ do
  Then 'I should receive an email'
  When 'I open the email'
  Then 'I should see "Activation Instructions" in the email subject'
end

When /^I click the activation email link$/ do
  When 'I click the first link in the email'
end