class AddIconToRaid < ActiveRecord::Migration
  def self.up
    add_column :raids, :icon, :string
  end

  def self.down
    remove_column :raids, :icon
  end
end
