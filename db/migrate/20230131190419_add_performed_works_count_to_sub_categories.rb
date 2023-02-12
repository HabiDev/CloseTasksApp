class AddPerformedWorksCountToSubCategories < ActiveRecord::Migration[7.0]
  def self.up
    add_column :sub_categories, :performed_works_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :sub_categories, :performed_works_count
  end
end
