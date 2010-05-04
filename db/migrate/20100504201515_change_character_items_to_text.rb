class ChangeCharacterItemsToText < ActiveRecord::Migration
  def self.up
    change_column :characters, :items, :text
  end

  def self.down
    change_column :characters, :items, :string
  end
end
