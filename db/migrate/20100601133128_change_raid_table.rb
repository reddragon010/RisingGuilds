class ChangeRaidTable < ActiveRecord::Migration
  def self.up
	change_table :raids do |t|
		t.column :date, :date, :null => false
    t.change :invite_start, :time
    t.change :start, :time
    t.change :end, :time
    t.column :max_lvl, :int, :null => true
    t.column :min_lvl, :int, :null => true
    end
  end

  def self.down
	change_table :raids do |t|
		t.column :date, :date, :null => false
    t.change :invite_start, :time
    t.change :start, :time
    t.change :end, :timee
    t.column :max_lvl, :int, :null => true
    t.column :min_lvl, :int, :null => true
    end
  end
end