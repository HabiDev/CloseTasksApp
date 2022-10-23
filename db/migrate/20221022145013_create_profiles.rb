class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles do |t|
      t.string :full_name,            null: false,    default: ""
      t.string :avatar
      t.string :mobile
      t.references :user,             null: false,    foreign_key: true
      t.references :sub_department,   null: false,    foreign_key: true
      t.references :position,         null: false,    foreign_key: true

      t.timestamps
    end
  end
end
