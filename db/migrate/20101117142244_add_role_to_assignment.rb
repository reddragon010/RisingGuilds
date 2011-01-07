class AddRoleToAssignment < ActiveRecord::Migration
  def self.up
    add_column :assignments, :role, :string
  end

  def self.down
    remove_column :assignments, :role
  end
end
