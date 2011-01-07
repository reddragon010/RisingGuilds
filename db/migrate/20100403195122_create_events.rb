class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :action
      t.string :content
      t.integer :guild_id
      t.integer :character_id

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
