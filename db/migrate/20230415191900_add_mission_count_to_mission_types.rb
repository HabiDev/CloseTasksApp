class AddMissionCountToMissionTypes < ActiveRecord::Migration[7.0]
  def self.up
    add_column :mission_types, :missions_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :mission_types, :mission_count
  end
end
