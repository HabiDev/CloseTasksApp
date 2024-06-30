class AddWorkloadToCompletedTask < ActiveRecord::Migration[7.0]
  def change
    add_column :completed_tasks, :workload, :integer, default: 1
  end
end
