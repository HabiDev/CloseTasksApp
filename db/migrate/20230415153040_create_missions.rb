class CreateMissions < ActiveRecord::Migration[7.0]
  def change
    create_table :missions do |t|
      t.string     :number,               null: false
      t.integer    :status,               null: false,  default: 1
      t.references :mission_type,         null: false,  foreign_key: true
      t.references :author,               null: false,  foreign_key: { to_table: :users },  default: 0
      t.string     :description,          null: false
      t.references :control_executor,     null: false,  foreign_key: { to_table: :users },  default: 0
      t.datetime   :execution_limit_at
      t.datetime   :close_at
      t.datetime   :read_at


      t.timestamps
    end
  end
end
