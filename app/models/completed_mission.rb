class CompletedMission < ApplicationRecord
  belongs_to :mission_executor

  validates :mission_executor_id, :description, presence: true

  # broadcasts_to ->(completed_task) { "completed_tasks" }, inserts_by: :prepend

  scope :ordered, -> { order(created_at: :desc) }  

end
