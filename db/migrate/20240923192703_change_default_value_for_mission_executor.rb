class ChangeDefaultValueForMissionExecutor < ActiveRecord::Migration[7.0]
  def change 
    change_column_default :mission_executors, :status, from: 1, to: 0
  end
end
