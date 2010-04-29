class AddAilStdDevToCharacter < ActiveRecord::Migration
  def self.up
    add_column :characters, :ailstddev, :integer
  end

  def self.down
    remove_column :characters, :ailstddev
  end
end
