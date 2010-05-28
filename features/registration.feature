Feature: Registration
	As a guest
	I want to get an account
	So that I can login
	
	Scenario: register an account
		Given I am on the signup page
		And I fill in "Login" with "test"
		And I fill in "Email" with "test@dreamblaze.net"
		And I press "Register"
		Then I should see "Your account has been created. Please check your e-mail for your account activation instructions!"
		And I should receive an activation email
		When I click the activation email link
		Then I should see "Activate your account"
		When I fill in "user_password" with "test"
		And I fill in "user_password_confirmation" with "test"
		And I press "Activate"
		Then I should see "Your account has been activated."
