Feature: Newsentries

	Background:
		Given a guild
		And a public newsentry
		And a private newsentry

  Scenario: View Newsentries as Member
	  Given I am a registered user
	  And I am a "member" of the guild
	  And I am logged in
	  When I go to the guildpage
		Then I should see "PublicTestEntry"
		And I should see "PrivateTestEntry"
		
	Scenario: View Newsentries as User
	 	Given I am a registered user
 	  And I am logged in
 	  When I go to the guildpage
 		Then I should see "PublicTestEntry"
		And I should not see "PrivateTestEntry"	
	  
