class FixingRegistrationNullError < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.change :crypted_password, :string, :null => true
      t.change :password_salt, :string, :null => true
    end
  end

  def self.down
    t.change :crypted_password, :string, :null => false
    t.change :password_salt, :string, :null => false
  end
end
