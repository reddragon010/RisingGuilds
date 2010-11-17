class MigrateRolesToNewFormat < ActiveRecord::Migration
#  def self.up
#    Assignment.all.each do |a|
#      a.update_attribute :role, Role.find(a.role_id).name
#    end
#  end

# def self.down
#    Assignment.all.each do |a|
#      a.update_attribute :role_id, Role.find_by_name(a.role).id
#    end
#  end
end