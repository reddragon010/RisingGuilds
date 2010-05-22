class CreateRaids < ActiveRecord::Migration
  def self.up
    create_table :raids do |t|
      t.integer :guild_id, :null => false
      t.string :title, :null => false
      t.integer :max_attendees, :default => 25
      t.datetime :invite_start
      t.datetime :start, :null => false
      t.datetime :end
      t.text :description
      t.integer :leader
      t.boolean :closed, :null => false, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :raids
  end
end
