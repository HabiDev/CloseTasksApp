class CreateCompletedTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :completed_tasks do |t|
      t.references :division,     null: false,    foreign_key: true
      t.references :user,         null: false,    foreign_key: true
      t.references :sub_category, null: false,    foreign_key: true
      t.text :comment

      t.timestamps
    end
  end
end
