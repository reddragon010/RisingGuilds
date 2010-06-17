Feature: Character
		
	Scenario: Create a new raid
		Given a guild
		And I am a registered user
		And I am a "leader" of the guild
		And I am logged in
		When I am on the new_raid-form
		And I fill in the following:
		 | Title       | TestRaid1     |
		 | Min lvl     | 1             |
		 | Max lvl     | 80            |
		 | Description | Test the Raid |
		And I select "2010-10-10 10:10" as the "start" date and time
		And I press "create"
		Then I should see "Raid was successfully created."

	Scenario: Visit empty raids-page
		Given a guild
		And I am a registered user
		And I am a "leader" of the guild
		And I am logged in
		And I am on the guildpage
		When I follow "Raids"
		Then I should see "There are no raids which could be attended by you"

	Scenario: Edit a raid
		Given a guild
		And a raid
		And I am a registered user
		And I am a "leader" of the guild
		And I am logged in
		When I am on the raidpage
		And I follow "Edit"
		And I fill in "Title" with "FooBar"
		And I press "Update"
		Then I should see "Raid was successfully updated."
		And I should see "FooBar"
		
	Scenario: Attend a Raid
		Given a guild
		And the guild have some members
		And a raid
		And I am a registered user
		And I am a "leader" of the guild
		And I am linked to a character
		And I am logged in
		When I am on the raidpage
		And I select "TestBoon1" from "attendance_character_id"
		And I select "dd" from "attendance_role"
		And I select "signed" from "attendance_status"
		And I fill in "attendance_message" with "TestAttendace"
		And I press "Create"
		Then I should see "Attendance was successfully created."
		When I select "tank" from "attendance_role"
		And I select "not_sure" from "attendance_status"
		And I fill in "attendance_message" with "TestAttendaceUpdate"
		And I press "Update"
		Then I should see "Attendance was successfully updated."
		
	
