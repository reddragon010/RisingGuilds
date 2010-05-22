require 'spec_helper'

describe "/attendances/edit.html.erb" do
  include AttendancesHelper

  before(:each) do
    assigns[:attendance] = @attendance = stub_model(Attendance,
      :new_record? => false,
      :character_id => 1,
      :raid_id => 1,
      :role => "value for role",
      :status => 1,
      :message => 
    )
  end

  it "renders the edit attendance form" do
    render

    response.should have_tag("form[action=#{attendance_path(@attendance)}][method=post]") do
      with_tag('input#attendance_character_id[name=?]', "attendance[character_id]")
      with_tag('input#attendance_raid_id[name=?]', "attendance[raid_id]")
      with_tag('input#attendance_role[name=?]', "attendance[role]")
      with_tag('input#attendance_status[name=?]', "attendance[status]")
      with_tag('input#attendance_message[name=?]', "attendance[message]")
    end
  end
end
