class AddTimestartToCompletedTask < ActiveRecord::Migration[7.0]
  def change
    add_column :completed_tasks, :time_start,  :time,    null: false
    add_column :completed_tasks, :time_end,    :time,    null: false   
  end
end
