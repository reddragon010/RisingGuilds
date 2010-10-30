class AddLastSyncToCharacter < ActiveRecord::Migration
  def self.up
    add_column :characters, :last_sync, :datetime
  end

  def self.down
    remove_column :characters, :last_sync
  end
end
