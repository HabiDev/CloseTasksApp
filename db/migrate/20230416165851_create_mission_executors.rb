class CreateMissionExecutors < ActiveRecord::Migration[7.0]
  def change
    create_table :mission_executors do |t|
      t.references :mission,              null: false,  foreign_key: true
      t.references :executor,             null: false,  foreign_key: { to_table: :users },  default: 0
      t.string     :description,          null: false  
      t.integer    :status,               null: false,  default: 1  
      t.datetime   :limit_at
      t.datetime   :close_at
      t.datetime   :read_at

      t.timestamps
    end
  end
end
