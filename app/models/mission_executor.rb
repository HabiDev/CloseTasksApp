class MissionExecutor < ApplicationRecord

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

  belongs_to :mission
  belongs_to :executor, class_name: "User", optional: true
  counter_culture :mission
  counter_culture :executor, column_name: "executor_missions_count"

  validates :mission_id, :executor_id, :description, presence: true

end
