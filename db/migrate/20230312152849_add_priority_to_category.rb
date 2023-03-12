class AddPriorityToCategory < ActiveRecord::Migration[7.0]
  def change
    add_reference :categories, :priority, null: false, foreign_key: true, default: 3
  end
end
