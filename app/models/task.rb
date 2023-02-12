class Task < ApplicationRecord
  before_save :set_execution_limit
  enum status: { registred: 0, 
                 in_work: 1, 
                 in_approval: 3, 
                 in_rework: 4, 
                 agree: 5, 
                 executed: 6,
                 not_executed: 7,
                 delayed: 8,
                 canceled: 9
                }
  has_many :performed_works, dependent: :destroy
  belongs_to :division, optional: true
  belongs_to :author, class_name: "User", optional: true  
  belongs_to :executor, class_name: "User", optional: true
  belongs_to :priority, optional: true
  counter_culture :division
  counter_culture :priority
  counter_culture :author, column_name: "author_tasks_count"
  counter_culture :executor, column_name: "executor_tasks_count"

  validates :division_id, :author_id, :executor_id, 
            :priority_id, :description, presence: true

  default_scope { order(created_at: :desc, priority_id: :asc, status: :asc, division_id: :asc) }

  scope :task_executors, ->(user) { where(executor_id: user.id) }

  def looked!
    unless self.read_at.present?
      self.read_at = DateTime.now
      self.status = :in_work
      self.save!
    end
  end

  private

  def set_execution_limit
    if self.priority.changed? || self.new_record?
      priority = Priority.find(self.priority_id)
      self.execution_limit_at = priority.limit_day.days.since
    end
  end


end