class AddProfilesCountToPositions < ActiveRecord::Migration[7.0]
  def self.up
    add_column :positions, :profiles_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :positions, :profiles_count
  end
end
