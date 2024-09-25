class MissionExecutor < ApplicationRecord

  enum status: { registred: 0, 
    in_work: 1, 
    in_approval: 3, 
    in_rework: 4, 
    agree: 5, 
    executed: 6,
    # dont_executed: 7,
    delayed: 8,
    canceled: 9
   }

  belongs_to :mission
  belongs_to :executor, class_name: "User", optional: true
  counter_culture :mission
  counter_culture :executor, column_name: "executor_missions_count"

  has_many :completed_missions, dependent: :destroy


  validates :mission_id, :executor_id, :parent_executor_id, :description, presence: true

  default_scope { order(parent_executor_id: :asc, limit_at: :desc) }

  scope :last_status, ->{ order(updated_at: :desc) }

  scope :executor_mission, ->(current_user) { where(executor_id: current_user) }

  scope :responsible_mission, ->{ where(responsible: true)}

  scope :opened, ->{ where(close_at: nil)}

  def mission_looked!
    unless self.read_at.present?
      self.read_at = DateTime.now
      self.status = :in_work
      self.save!
    end
  end

  def self.parent_for_executor(mission)
    MissionExecutor.where("mission_id = ? and parent_executor_id = 0", mission).order(["responsible", "limit_at ASC"])
  end

  def self.replies_for_executor(mission)
    MissionExecutor.where("mission_id = ? and parent_executor_id != 0", mission).order(["executor_id", "id"]).group_by {|mission_executor| mission_executor["parent_executor_id"] }
  end

end
