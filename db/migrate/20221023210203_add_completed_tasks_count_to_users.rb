class AddCompletedTasksCountToUsers < ActiveRecord::Migration[7.0]
  def self.up
    add_column :users, :completed_tasks_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :users, :completed_tasks_count
  end
end
