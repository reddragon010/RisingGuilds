class CorrectSomeSillyThings < ActiveRecord::Migration
  def self.up
    change_table :characters do |t|
      t.change :name, :string, :null => false
      t.change :online, :boolean, :null => false
      t.change_default :online, false
      t.change :activity, :integer, :null => false
      t.change_default :activity, 0
      t.change :main, :boolean, :null => false
      t.change_default :main, false
      t.change :items, :text, :limit => 2000
      t.change :realm, :string, :null => false
    end
    
    change_table :events do |t|
      t.change :action, :string, :null => false
    end
    
    change_table :guilds do |t|
      t.change :name, :string, :null => false
      t.remove :officer_rank
      t.remove :raidleader_rank
      t.rename :ration, :rating
      t.change :token, :string, :null => false
      t.change :realm, :string, :null => false
    end
    
    change_table :remote_queries do |t|
      t.change :priority, :integer, :null => false
      t.change :efford, :integer, :null => false
      t.change :action, :string, :null => false
    end
    
    change_table :roles do |t|
      t.change :name, :string, :null => false
    end
    
    change_table :users do |t|
      t.change :admin, :boolean, :null => false
      t.change_default :admin, false
    end
  end

  def self.down
    change_table :characters do |t|
      t.change :name, :string, :null => true
      t.change :online, :boolean, :null => true
      t.change_default :online, nil
      t.change :activity, :integer, :null => true
      t.change_default :activity, nil
      t.change :main, :boolean, :null => true
      t.change_default :main, nil
      t.change :items, :text, :limit => 255
      t.change :realm, :string, :null => true
    end
    
    change_table :events do |t|
      t.change :action, :string, :null => true
    end
    
    change_table :guilds do |t|
      t.change :name, :string, :null => true
      t.column :officer_rank, :integer
      t.column :raidleader_rank, :integer
      t.rename :rating, :ration
      t.change :token, :string, :null => true
      t.change :realm, :string, :null => true
    end
    
    change_table :remote_queries do |t|
      t.change :priority, :integer, :null => true
      t.change :efford, :integer, :null => true
      t.change :action, :string, :null => true
    end
    
    change_table :roles do |t|
      t.change :name, :string, :null => true
    end
    
    change_table :users do |t|
      t.change :admin, :boolean, :null => true
      t.change_default :admin, nil
    end
  end
end
