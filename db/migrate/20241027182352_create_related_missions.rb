class CreateRelatedMissions < ActiveRecord::Migration[7.0]
  def change
    create_table :related_missions do |t|
      t.references  :mission,         null: false,  foreign_key: true
      t.integer     :related,         null: false,  default: 0
      t.string      :number_mission  

      t.timestamps
    end
  end
end
