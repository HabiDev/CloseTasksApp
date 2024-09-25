class AddParentExecutorToMissionExecutors < ActiveRecord::Migration[7.0]
  def change
    add_column :mission_executors, :parent_executor_id, :integer, default: 0, null: false
    add_column :mission_executors, :coordinator_id, :integer, default: 0, null: false
    add_column :mission_executors, :responsible, :boolean, default: false
  end
end
