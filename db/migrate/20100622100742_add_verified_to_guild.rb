class AddVerifiedToGuild < ActiveRecord::Migration
  def self.up
    add_column :guilds, :verified, :boolean
  end

  def self.down
    remove_column :guilds, :verified
  end
end
