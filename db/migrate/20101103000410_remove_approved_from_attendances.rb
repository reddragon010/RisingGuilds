class RemoveApprovedFromAttendances < ActiveRecord::Migration
  def self.up
    remove_column :attendances, :approved
  end

  def self.down
    add_column :attendances, :approved, :boolean
  end
end
