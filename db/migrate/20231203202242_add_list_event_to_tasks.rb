class AddListEventToTasks < ActiveRecord::Migration[7.0]
  def change
    add_reference :tasks, :list_event, foreign_key: true
  end
end
