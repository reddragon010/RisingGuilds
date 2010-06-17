class CreateGuildsRaidsJoinTable < ActiveRecord::Migration
  def self.up
    create_table :guilds_raids, :id => false do |t|
      t.integer :guild_id
      t.integer :raid_id
    end
  end

  def self.down
    add_column :raids, :guild_id, :integer, :null => false
  end
end
