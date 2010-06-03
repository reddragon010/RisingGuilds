class AddApprovedToAttendances < ActiveRecord::Migration
  def self.up
    add_column :attendances, :approved, :boolean, :default => false
  end

  def self.down
    remove_column :attendances, :approved
  end
end
