class CreateCharacters < ActiveRecord::Migration
  def self.up
    create_table :characters do |t|
      t.integer :guild_id
      t.integer :user_id
      t.string :name
      t.integer :rank
      t.integer :level
      t.boolean :online
      t.datetime :last_seen
      t.integer :activity
      t.integer :class_id
      t.integer :race_id
      t.integer :faction_id
      t.integer :gender_id
      t.integer :achivementpoints
      t.integer :ail
      t.string :talentspec1
      t.string :talentspec2
      t.string :profession1
      t.string :profession2
      t.boolean :main

      t.timestamps
    end
  end

  def self.down
    drop_table :characters
  end
end
