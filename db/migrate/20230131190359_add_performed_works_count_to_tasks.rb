class AddPerformedWorksCountToTasks < ActiveRecord::Migration[7.0]
  def self.up
    add_column :tasks, :performed_works_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :tasks, :performed_works_count
  end
end
