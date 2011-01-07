class AddLimitsToRaids < ActiveRecord::Migration
  def self.up
    add_column :raids, :limit_roles, :string
    add_column :raids, :limit_classes, :string
  end

  def self.down
    remove_column :raids, :limit_classes
    remove_column :raids, :limit_roles
  end
end
