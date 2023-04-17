class AddMissionExecutorsCountToMissions < ActiveRecord::Migration[7.0]
  def self.up
    add_column :missions, :mission_executors_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :missions, :mission_executors_count
  end
end
