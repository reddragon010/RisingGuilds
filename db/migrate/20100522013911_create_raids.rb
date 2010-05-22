class CreateRaids < ActiveRecord::Migration
  def self.up
    create_table :raids do |t|
      t.integer :guild_id
      t.string :title
      t.integer :max_attendees
      t.datetime :invite_start
      t.datetime :start
      t.datetime :end
      t.text :description
      t.integer :leader
      t.boolean :closed

      t.timestamps
    end
  end

  def self.down
    drop_table :raids
  end
end
