class AddFactionToGuild < ActiveRecord::Migration
  def self.up
    add_column :guilds, :faction_id, :integer
  end

  def self.down
    remove_column :guilds, :faction_id
  end
end
