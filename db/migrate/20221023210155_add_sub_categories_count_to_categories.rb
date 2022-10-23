class AddSubCategoriesCountToCategories < ActiveRecord::Migration[7.0]
  def self.up
    add_column :categories, :sub_categories_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :categories, :sub_categories_count
  end
end
