class AddRealmToCharacter < ActiveRecord::Migration
  def self.up
    add_column :characters, :realm, :string
  end

  def self.down
    remove_column :characters, :realm
  end
end
