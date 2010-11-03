class AddAutoConfirmToRaids < ActiveRecord::Migration
  def self.up
    add_column :raids, :autoconfirm, :boolean, :default => false
  end

  def self.down
    remove_column :raids, :autoconfirm
  end
end
