class MigrateRolesToNewFormat < ActiveRecord::Migration
  def self.up
    if Assignment.column_names.include?('role_id') && Assignment.column_names.include?('role')
      Assignment.all.each do |a|
        a.update_attribute :role, Role.find(a.role_id).name
      end
    end
  end

 def self.down
    if Assignment.column_names.include?('role_id') && Assignment.column_names.include?('role')
      Assignment.all.each do |a|
        a.update_attribute :role_id, Role.find_by_name(a.role).id
      end
    end
  end
end