class AddItemsToCharacter < ActiveRecord::Migration
  def self.up
    add_column :characters, :items, :string
  end

  def self.down
    remove_column :characters, :items
  end
end
