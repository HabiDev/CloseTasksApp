class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.references :division,           null: false,  foreign_key: true,  default: 0      
      t.integer    :status,             null: false,  default: 0
      t.string     :description,        null: false
      t.references :priority,           null: false,  foreign_key: true,  default: 0     
      t.references :executor,           null: false,  foreign_key: { to_table: :users },  default: 0
      t.references :author,             null: false,  foreign_key: { to_table: :users },  default: 0
      t.datetime   :execution_limit_at, null: false
      t.datetime   :close_at
      t.datetime   :read_at

      t.timestamps
    end
  end
end
