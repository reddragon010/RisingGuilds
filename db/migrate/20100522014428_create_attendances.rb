class CreateAttendances < ActiveRecord::Migration
  def self.up
    create_table :attendances do |t|
      t.integer :character_id
      t.integer :raid_id
      t.string :role
      t.integer :status
      t.sting :message

      t.timestamps
    end
  end

  def self.down
    drop_table :attendances
  end
end
