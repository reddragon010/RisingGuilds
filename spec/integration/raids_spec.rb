require 'spec_helper'

describe "Raids" do
  fixtures :roles
  
  before(:each) do
    @guild = Guild.first || Factory(:Guild) 
    visit root_path 
  end
  
  context "a member with no raids" do
    before(:each) do
      login
      assing_user_to_guild_as("member")
    end
    
    it "should see a no-raids message" do
      visit raids_path
      page.should have_content("There are no raids which could be attended by you")
    end
  end
  
  context "a member with a character" do
    before(:each) do
      (1..5).each do 
        @guild.characters << Factory(:Character)
      end
      login
      assing_user_to_guild_as("member")
      @char = @guild.characters.first
      @user.characters << @char
      @user.save
      @raid = Factory(:Raid, :guild_id => @guild.id)
    end
    
    it "should be able to attend a raid" do
      visit raid_path(@raid)
      select @char.name, :from => 'attendance_character_id'
      select 'dd', :from => 'attendance_role'
      select "signed", :from => "attendance_status"
      fill_in "attendance_message",:with =>"TestAttendace" 
      click 'Create'
      page.should have_css(".notice")
  		page.should have_content(@char.name)
  		page.should have_content('TestAttendace')
    end
    
    it "should be able to update a existing raid-attendance" do
      @raid.attendances << Attendance.create(:character_id => @char.id, :raid_id => @raid.id, :role => "dd", :status => 2)
      visit raid_path(@raid)
      select @char.name, :from => 'attendance_character_id'
      select 'tank', :from => 'attendance_role'
      fill_in "attendance_message",:with => "NewTestAttendace"
      click 'Update'
      page.should have_css(".notice")
  		page.should have_content('tank')
  		page.should have_content('NewTestAttendace')
    end
  end
  
  context "a leader" do
    before(:each) do
      login
      assing_user_to_guild_as("leader")
    end
    
    it "should be able to create a raid" do
      visit new_guild_raid_path(@guild)
      fill_in 'Title',:with => 'TestRaid1'
  		fill_in 'Min lvl',:with => '1'
  		fill_in 'Max lvl',:with => '80'
  		fill_in 'Description',:with => 'Test the Raid'
  		select "Naxxramas", :from => 'raid_icon'
  		click "Create"
  		page.should have_css(".notice")
  		page.should have_content('TestRaid1')
    end
    
    it "should be able to edit a raid" do
      @raid = Factory(:Raid, :guild_id => @guild.id)
      visit raid_path(@raid)
      click "Edit"
      fill_in 'Title',:with => 'FooBar'
      click 'Update'
      page.should have_css(".notice")
  		page.should have_content('FooBar')
    end
  end
end
