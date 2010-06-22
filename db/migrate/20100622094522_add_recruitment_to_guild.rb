class AddRecruitmentToGuild < ActiveRecord::Migration
  def self.up
    add_column :guilds, :recruit_text, :text
    add_column :guilds, :recruit_open, :boolean
    add_column :guilds, :recruit_dk, :boolean
    add_column :guilds, :recruit_druid, :boolean
    add_column :guilds, :recruit_hunter, :boolean
    add_column :guilds, :recruit_mage, :boolean
    add_column :guilds, :recruit_paladin, :boolean
    add_column :guilds, :recruit_priest, :boolean
    add_column :guilds, :recruit_rogue, :boolean
    add_column :guilds, :recruit_shaman, :boolean
    add_column :guilds, :recruit_warlock, :boolean
    add_column :guilds, :recruit_warrior, :boolean
    add_column :guilds, :recruit_healer, :boolean
    add_column :guilds, :recruit_damage, :boolean
    add_column :guilds, :recruit_tank, :boolean
  end

  def self.down
    remove_column :guilds, :recruit_tank
    remove_column :guilds, :recruit_damage
    remove_column :guilds, :recruit_healer
    remove_column :guilds, :recruit_warrior
    remove_column :guilds, :recruit_warlock
    remove_column :guilds, :recruit_shaman
    remove_column :guilds, :recruit_rogue
    remove_column :guilds, :recruit_priest
    remove_column :guilds, :recruit_paladin
    remove_column :guilds, :recruit_mage
    remove_column :guilds, :recruit_hunter
    remove_column :guilds, :recruit_druid
    remove_column :guilds, :recruit_dk
    remove_column :guilds, :recruit_open
    remove_column :guilds, :recruit_text
  end
end
