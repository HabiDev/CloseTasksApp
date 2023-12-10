class CreateCheckListGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :check_list_groups do |t|
      t.string :name,     null: false,    default: ""

      t.timestamps
    end
  end
end
