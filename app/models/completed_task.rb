class CompletedTask < ApplicationRecord
  belongs_to :division
  belongs_to :user
  belongs_to :sub_category, class_name: 'SubCategory', foreign_key: :sub_category_id
  counter_culture :sub_category
  counter_culture :user
  counter_culture :division
  has_many :category, through: :sub_category


  validates :division_id, :user_id, :sub_category_id, :time_start, :time_end, :workload, presence: true

  # broadcasts_to ->(completed_task) { "completed_tasks" }, inserts_by: :prepend

  scope :ordered, -> { order(created_at: :desc) }  

  scope :created_date, -> (shares_at) { where(created_at: shares_at.beginning_of_day..shares_at.end_of_day) }

  scope :date_between, ->(date_start, date_end) { where('completed_tasks.created_at >= ? AND completed_tasks.created_at <= ?', date_start, date_end) }

  scope :sub_category_completed_tasks, -> { select("sub_categories.name").joins(:sub_category).order("sub_categories.name")
                                  .group("sub_categories.name").count(:sub_category_id) }
  scope :user_completed_tasks, ->(user) { where('completed_tasks.user_id = ? ', user) }
end
 