class AddVisibleToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :visible, :boolean, :default => true
  end

  def self.down
    remove_column :events, :visible
  end
end
