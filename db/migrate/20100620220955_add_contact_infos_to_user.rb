class AddContactInfosToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :icq, :string
    add_column :users, :msn, :string
    add_column :users, :skype, :string
    add_column :users, :jabber, :string
  end

  def self.down
    remove_column :users, :jabber
    remove_column :users, :skype
    remove_column :users, :msn
    remove_column :users, :icq
  end
end
