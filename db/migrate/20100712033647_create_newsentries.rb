class CreateNewsentries < ActiveRecord::Migration
  def self.up
    create_table :newsentries do |t|
      t.string :title, :null => false
      t.integer :user_id, :null => false
      t.text :body, :null => false
      t.boolean :public, :null => false, :default => false
      t.boolean :sticky, :null => false, :default => false
      t.integer :guild_id, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :newsentries
  end
end
