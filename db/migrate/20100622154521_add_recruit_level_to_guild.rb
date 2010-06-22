class AddRecruitLevelToGuild < ActiveRecord::Migration
  def self.up
    add_column :guilds, :recruit_level, :integer
  end

  def self.down
    remove_column :guilds, :recruit_level
  end
end
