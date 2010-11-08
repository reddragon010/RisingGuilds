class AddApiKeyToGuild < ActiveRecord::Migration
  def self.up
    add_column :guilds, :apikey, :string
  end

  def self.down
    remove_column :guilds, :apikey
  end
end
