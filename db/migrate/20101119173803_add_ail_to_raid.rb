class AddAilToRaid < ActiveRecord::Migration
  def self.up
    add_column :raids, :min_ail, :integer
  end

  def self.down
    remove_column :raids, :min_ail
  end
end
