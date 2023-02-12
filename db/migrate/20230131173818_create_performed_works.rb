class CreatePerformedWorks < ActiveRecord::Migration[7.0]
  def change
    create_table :performed_works do |t|
      t.references :sub_category,     null: false,    foreign_key: true
      t.references :task,             null: false,    foreign_key: true
      t.time       :time_start,       null: false
      t.time       :time_end,         null: false 
      t.text       :comment

      t.timestamps
    end
  end
end
