class AddControlExecutorMissionsCountToUsers < ActiveRecord::Migration[7.0]
  def self.up
    add_column :users, :control_executor_missions_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :users, :control_executor_missions_count
  end
end
