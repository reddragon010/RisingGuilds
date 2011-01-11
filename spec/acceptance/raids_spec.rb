require File.dirname(__FILE__) + '/acceptance_helper'

feature "Raids" do
  
  let :guild do
    Factory :Guild
  end
  
  let :user do
    Factory :User
  end
  
  let :raid do
    Factory(:Raid, :guild_id => guild.id)
  end
  
  before(:each) do
    (1..5).each do 
      guild.characters << Factory(:Character)
    end
    @char = guild.characters.first
    user.characters << @char
    user.save
    user.assignments << Factory.create(:Assignment, :guild_id => guild.id, :role => "member")
    log_in_with user
    visit "/" 
  end
    
  scenario "members should see a no-raids message" do
    visit "/raids"
    page.should have_content("There are no raids which could be attended by you")
  end
  
#TODO: Adapt the tests to use a javascript-compatible driver or change the testflow
=begin    
  scenario "members should be able to attend a raid" do
    visit "/raids/#{raid.id}"
    select @char.name, :from => 'attendance_character_id'
    select 'Range', :from => 'attendance_role'
    select "Available", :from => "attendance_status"
    fill_in "attendance_message",:with =>"TestAttendace" 
    click_button 'Create'
    page.should have_css(".notice")
    page.should have_content(@char.name)
    page.should have_content('TestAttendace')
  end

  scenario "should be able to update a existing raid-attendance" do
    raid.attendances << Attendance.create(:character_id => @char.id, :raid_id => raid.id, :role => "dd", :status => 2)
    visit "/raids/#{raid.id}"
    click_link 'new_attendance'
    select @char.name, :from => 'attendance_character_id'
    select 'Tank', :from => 'attendance_role'
    fill_in "attendance_message",:with => "NewTestAttendace"
    click_link_or_button 'Update'
    page.should have_css(".notice")
    page.should have_content('Tank')
    page.should have_content('NewTestAttendace')
  end
=end 
    
  scenario "should be able to create a raid" do
    user.assignments << Factory.create(:Assignment, :guild_id => guild.id, :role => "leader")
    visit "/guilds/#{guild.id}/raids/new"
    fill_in 'raid_title',:with => 'TestRaid1'
    fill_in 'raid_min_lvl',:with => '1'
    fill_in 'raid_max_lvl',:with => '80'
    fill_in 'raid_description',:with => 'Test the Raid'
    select "Naxx", :from => 'raid_icon'
    click_button "Create"
    page.should have_css(".notice")
    page.should have_content('TestRaid1')
  end
   
  scenario "should be able to edit a raid" do
    user.assignments << Factory.create(:Assignment, :guild_id => guild.id, :role => "leader")
    visit "/raids/#{raid.id}"
    click_link "Edit"
    fill_in 'Title',:with => 'FooBar'
    click_button 'Update'
    page.should have_css(".notice")
    page.should have_content('FooBar')
  end
  
end
