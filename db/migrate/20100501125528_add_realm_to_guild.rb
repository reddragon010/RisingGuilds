class AddRealmToGuild < ActiveRecord::Migration
  def self.up
    add_column :guilds, :realm, :string
  end

  def self.down
    remove_column :guilds, :realm
  end
end
