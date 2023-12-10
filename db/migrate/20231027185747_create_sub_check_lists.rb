class CreateSubCheckLists < ActiveRecord::Migration[7.0]
  def change
    create_table :sub_check_lists do |t|
      t.string      :name,              null: false,    default: ""
      t.references  :check_list_type,   null: false,    foreign_key: true
      t.references  :check_list_group,  null: false,    foreign_key: true

      t.timestamps
    end
  end
end
