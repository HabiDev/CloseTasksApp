class CreateCheckLists < ActiveRecord::Migration[7.0]
  def change
    create_table :check_lists do |t|
      t.references :division,           null: false,  foreign_key: true
      t.references :check_list_type,    null: false,  foreign_key: true
      t.references :author,             null: false,  foreign_key: { to_table: :users },  default: 0
      t.boolean    :status,             default: false

      t.timestamps
    end
  end
end
