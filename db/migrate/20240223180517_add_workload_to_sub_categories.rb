class AddWorkloadToSubCategories < ActiveRecord::Migration[7.0]
  def change
    add_column :sub_categories, :workload, :boolean, default: false
  end
end
