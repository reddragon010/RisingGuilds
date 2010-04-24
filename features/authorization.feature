Feature: Authorization
	As a Guest or User
	I want to have some restrictions
	So that I can feel save
	
	Scenario: Create Guild as Guest
		Given I am on the homepage
		When I go to a new guild
		Then I should see "Sorry, you are not allowed to access that page."
		
	Scenario: Sync Guild as Guest
		Given a guild
		When I go to actualize guild
		Then I should see "Sorry, you are not allowed to access that page."
	
	Scenario: Edit Guild as Guest
		Given a guild
		When I go to edit guild
		Then I should see "Sorry, you are not allowed to access that page."
		
	Scenario: Create Guild as User
		Given a guild
		And I am a registered user
		And I am logged in
		When I go to a new guild
		And fill in some guildinfos
		And I press "create"
		Then I should see "Guild was successfully created."
		
	Scenario: Sync Guild as Guildmanager
		Given a guild
		And I am a registered user
		And I am a "guildmanager" of the guild
		And I am logged in
		And I am on the guildpage
		When I follow "Actualize"
		Then I should see "Guild will be updated soon"

#	Scenario: Edit Guild as Guildmanager
#		Given a Guild
#		When I go to edit guild
#		And fill in "name" with "Divinee"
#		And I press "update"
#		Then I should see "Guild was successfully edited."
#		And I should see "Devinee"
	
	
		
		
