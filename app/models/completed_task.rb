class CompletedTask < ApplicationRecord
  belongs_to :division
  belongs_to :user
  belongs_to :sub_category, class_name: 'SubCategory', foreign_key: :sub_category_id
  counter_culture :sub_category
  counter_culture :user
  counter_culture :division


  validates :division_id, :user_id, :sub_category_id, :time_start, :time_end, presence: true

  # broadcasts_to ->(completed_task) { "completed_tasks" }, inserts_by: :prepend

  scope :ordered, -> { order(created_at: :desc) }  

  scope :created_date, -> (shares_at) { where(created_at: shares_at.beginning_of_day..shares_at.end_of_day) }
end
