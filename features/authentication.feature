Feature: Authentication
	As an guest
	I want to login
	So that I can access my account
		
	Scenario: login as a valid user
		Given I am a registered user
		And I am on the homepage
		When I login
		Then I should see "Login successful!"
		And I should see "Logout"
		
	Scenario: login with invalid password
		And I am on the homepage
		When I login as "test" with password "fail"
		Then I should see "Login or Password incorrect!"
		
	Scenario: logout
		Given I am logged in
		And I am on the homepage
		When I follow "Logout"
		Then I should see "Logout successful!"
		And I should see "SignUp"
		And I should see "Login"
		
	Scenario: access account
		Given I am logged in
		And I am on the homepage
		When I follow "User"
		Then I should see my account
		
		
