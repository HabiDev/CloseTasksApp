class CreateCompletedMissions < ActiveRecord::Migration[7.0]
  def change
    create_table :completed_missions do |t|
      t.references :mission_executor,   null: false, foreign_key: true
      t.text       :description,        null: false
      t.text       :comment

      t.timestamps
    end
  end
end
