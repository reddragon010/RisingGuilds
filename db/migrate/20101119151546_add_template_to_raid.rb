class AddTemplateToRaid < ActiveRecord::Migration
  def self.up
    add_column :raids, :template, :boolean
  end

  def self.down
    remove_column :raids, :template
  end
end
