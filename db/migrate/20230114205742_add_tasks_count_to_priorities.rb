class AddTasksCountToPriorities < ActiveRecord::Migration[7.0]
  def self.up
    add_column :priorities, :tasks_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :priorities, :tasks_count
  end
end
