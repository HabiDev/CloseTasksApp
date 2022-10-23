class CreateDivisions < ActiveRecord::Migration[7.0]
  def change
    create_table :divisions do |t|
      t.string  :name,       null: false,    default: ""
      t.references :department, null: false, foreign_key: true
      t.string  :address,    null: false,    default: "" 
      t.string  :email   
      t.string  :photo
      t.float   :latitude,   null: false,    default: 0
      t.float   :longitude,  null: false,    default: 0
      t.boolean :active,    default: true

      t.timestamps
    end
  end
end
