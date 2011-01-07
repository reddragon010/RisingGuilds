class AddTeamspeakToGuild < ActiveRecord::Migration
  def self.up
    add_column :guilds, :teamspeak, :string
  end

  def self.down
    remove_column :guilds, :teamspeak
  end
end
