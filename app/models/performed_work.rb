class PerformedWork < ApplicationRecord
  belongs_to :sub_category, class_name: 'SubCategory', foreign_key: :sub_category_id
  belongs_to :task
  counter_culture :sub_category
  counter_culture :task

  validates :task_id, :sub_category_id, :time_start, :time_end, :workload, presence: true

  default_scope { order(created_at: :desc) }

  scope :date_between, ->(date_start, date_end) { joins(:task)
                                                  .where('tasks.created_at >= ? AND tasks.created_at <= ?', date_start, date_end) }
  
  scope :executed_status, -> { joins(:task).where('tasks.status = 6') }

  scope :sub_category_tasks, -> { select("sub_categories.name").joins(:sub_category).order("sub_categories.name")
                                  .unscope(:order).group("sub_categories.name").count(:sub_category_id) }
  scope :user_performed_works, ->(user) { where('tasks.executor_id = ? ', user).joins(:task) }

end
