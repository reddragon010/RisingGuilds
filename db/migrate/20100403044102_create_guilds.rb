class CreateGuilds < ActiveRecord::Migration
  def self.up
    create_table :guilds do |t|
      t.string :name
      t.integer :officer_rank
      t.integer :raidleader_rank
      t.integer :ail
      t.integer :activity
      t.integer :growth
      t.integer :altratio
      t.integer :classratio
      t.integer :achivementpoints
      t.integer :ration
      t.string :token
      t.string :website
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :guilds
  end
end
