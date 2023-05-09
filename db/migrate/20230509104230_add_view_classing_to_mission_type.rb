class AddViewClassingToMissionType < ActiveRecord::Migration[7.0]
  def change
    add_column :mission_types, :view_classing, :string, default: "info"
  end
end
