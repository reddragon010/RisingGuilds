class ChangeRaidTable < ActiveRecord::Migration
  def self.up
	change_table :raids do |t|
		t.column :date, :date, :null => false, :default => 'now()'
    t.change :invite_start, :time
    t.change :start, :time
    t.change :end, :time
    t.column :max_lvl, :int, :null => true
    t.column :min_lvl, :int, :null => true
    end
  end

  def self.down
	change_table :raids do |t|
    t.change :invite_start, :datetime
    t.change :start, :datetime
    t.change :end, :datetime
    t.remove :max_lvl, :min_lvl, :date
    end
  end
end