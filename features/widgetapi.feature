Feature: WidgetApi
	As a User
	I want to access the WidgetAPI
	So that I can use the functions
	
	Background:
		Given a guild named "Divine"
		And I am a registered user
		And I am logged in
	
	Scenario: Access with wrong API-Token
		Given I got an wrong apikey
		When I go to Divine's onlinemembers-widget
		Then I should see "Invalid API Key"
		
	Scenario: Access with valid API-Token
		Given I got an apikey
		When I go to Divine's onlinemembers-widget
		Then I should not see "Invalid API Key"
		
	Scenario: Get onlinemember-widget
		Given I got an apikey
		And I am a "leader" of the guild
		When I go to Divine's onlinemembers-widget
		Then I should see "document.write("
		
