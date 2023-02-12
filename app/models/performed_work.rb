class PerformedWork < ApplicationRecord
  belongs_to :sub_category, class_name: 'SubCategory', foreign_key: :sub_category_id
  belongs_to :task
  counter_culture :sub_category
  counter_culture :task

  validates :task_id, :sub_category_id, :time_start, :time_end, presence: true

  default_scope { order(created_at: :desc) }
 
end
