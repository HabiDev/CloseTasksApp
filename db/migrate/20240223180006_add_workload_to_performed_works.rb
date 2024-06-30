class AddWorkloadToPerformedWorks < ActiveRecord::Migration[7.0]
  def change
    add_column :performed_works, :workload, :integer, default: 1
  end
end
