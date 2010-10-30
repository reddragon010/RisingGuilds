class AddLastSyncToGuild < ActiveRecord::Migration
  def self.up
    add_column :guilds, :last_sync, :datetime
  end

  def self.down
    remove_column :guilds, :last_sync
  end
end
