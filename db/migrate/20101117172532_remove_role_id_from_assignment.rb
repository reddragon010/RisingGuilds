class RemoveRoleIdFromAssignment < ActiveRecord::Migration
  def self.up
    remove_column :assignments, :role_id
  end

  def self.down
    add_column :assignments, :role_id, :integer
  end
end
