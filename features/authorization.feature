Feature: Authorization
	As a Guest or User
	I want to have some restrictions
	So that I can feel save
	
	Scenario: Create Guild as Guest
		Given I am on the homepage
		When I go to a new guild
		Then I should see "Sorry, you are not allowed to access that page."
		
	Scenario: Sync Guild as Guest
		Given a Guild
		And I am on the Guildpage
		When I follow "Sync Guild with Arsenal"
		Then I should see "Sorry, you are not allowed to access that page."
		
	
		
		
