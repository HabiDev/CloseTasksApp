class AddProfilesCountToDepartments < ActiveRecord::Migration[7.0]
  def self.up
    add_column :departments, :profiles_count,          :integer, null: false, default: 0
    add_column :departments, :sub_departments_count,   :integer, null: false, default: 0
  end

  def self.down
    remove_column :departments, :profiles_count
  end
end
