class CreateRemoteQueries < ActiveRecord::Migration
  def self.up
    create_table :remote_queries do |t|
      t.integer :priority
      t.integer :efford
      t.string :action
      t.integer :character_id
      t.integer :guild_id

      t.timestamps
    end
  end

  def self.down
    drop_table :remote_queries
  end
end
