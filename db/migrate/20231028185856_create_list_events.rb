class CreateListEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :list_events do |t|
      t.references  :check_list,           null: false, foreign_key: true
      t.references  :sub_check_list,       null: false, foreign_key: true
      t.string      :comment
      t.integer     :check_status,         null: false, default: 2

      t.timestamps
    end
  end
end
