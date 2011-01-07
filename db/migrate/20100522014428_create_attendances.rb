class CreateAttendances < ActiveRecord::Migration
  def self.up
    create_table :attendances do |t|
      t.integer :character_id, :null => false
      t.integer :raid_id, :null => false
      t.string :role, :null => false
      t.integer :status, :null => false, :default => 1
      t.string :message

      t.timestamps
    end
  end

  def self.down
    drop_table :attendances
  end
end
