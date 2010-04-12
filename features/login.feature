Feature: Login
	As an guest
	I want to login
	So that I can access my account
	
	Background:
		Given a user "test"
		When I go to the login page
		
	Scenario: login as a valid user
		When I login as "test" with password "password"
		Then I should see "Login successful!"
		
	Scenario: login with invalid password
		When I login as "test" with password "invalid" 
		Then I should see "Login or Password incorrect!"
		
	Scenario: logout
		When I login as "test" with password "password"
		Then I should see "Login successful!"
		And I go to the logout page
		Then I should see "Logout successful!"
		
		
