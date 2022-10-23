class AddDivisionCountToDepartments < ActiveRecord::Migration[7.0]
  def self.up
    add_column :departments, :divisions_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :departments, :division_count
  end
end
