class CreateSubDepartments < ActiveRecord::Migration[7.0]
  def change
    create_table :sub_departments do |t|
      t.string :name,   null: false,    default: ""
      t.references :department, null: false, foreign_key: true

      t.timestamps
    end
  end
end
