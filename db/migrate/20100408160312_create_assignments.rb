class CreateAssignments < ActiveRecord::Migration
  def self.up
    create_table :assignments do |t|
      t.integer :role_id
      t.integer :user_id
      t.integer :guild_id

      t.timestamps
    end
  end

  def self.down
    drop_table :assignments
  end
end
