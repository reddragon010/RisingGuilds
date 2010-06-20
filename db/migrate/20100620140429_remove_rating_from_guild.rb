class RemoveRatingFromGuild < ActiveRecord::Migration
  def self.up
    change_table :guilds do |t|
      t.remove :ail, :activity, :growth, :altratio, :classratio, :achivementpoints
    end
  end

  def self.down
    change_table :guilds do |t|
      t.integer  "ail"
      t.integer  "activity"
      t.integer  "growth"
      t.integer  "altratio"
      t.integer  "classratio"
      t.integer  "achivementpoints"
    end
  end
end
