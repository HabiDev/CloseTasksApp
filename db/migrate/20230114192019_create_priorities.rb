class CreatePriorities < ActiveRecord::Migration[7.0]
  def change
    create_table :priorities do |t|
      t.string    :name,      null: false,    default: ""
      t.integer   :limit_day, null: false,    default: 3
      t.timestamps
    end
  end
end
