Feature: Character
		
	Scenario: Mark and Unmark a character
		Given a guild
		And the guild have some members
		And I am a registered user
		And I am a "member" of the guild
		And I am logged in
		And I am on the guildmembers-page
		When I follow "TestBoon1"
		And I follow "Mark as Mine!"
		Then I should see "Character is now yours"
		When I follow "Not Mine!"
		Then I should see "Character has been demarked"
		
