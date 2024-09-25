class CreateMissionApprovals < ActiveRecord::Migration[7.0]
  def change
    create_table :mission_approvals do |t|
      t.references :mission, null: false, foreign_key: true
      t.integer :mission_executor_id, null: false
      t.integer :coordinator_id, null: false

      t.timestamps
    end
  end
end
