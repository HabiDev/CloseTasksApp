class AddGenderToPorfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :gender, :integer, null: false, default: 0
  end
end
