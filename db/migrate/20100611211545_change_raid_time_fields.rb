class ChangeRaidTimeFields < ActiveRecord::Migration
  def self.up
    change_table :raids do |t|
      t.change :invite_start, :datetime
      t.change :start, :datetime
      t.change :end, :datetime
      t.remove :date
    end
  end

  def self.down
    change_table :raids do |t|
      t.change :invite_start, :time
      t.change :start, :time
      t.change :end, :time
      t.column :date, :date, :null => false, :default => 'now()'
    end
  end
end
