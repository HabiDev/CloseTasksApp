class Mission < ApplicationRecord
  attr_accessor :responsible_executor_id

  enum status: { registred: 0, 
    in_work: 1, 
    in_approval: 3, 
    in_rework: 4, 
    agree: 5, 
    executed: 6,
    # not_executed: 7,
    delayed: 8,
    canceled: 9
   }
  
  before_save :set_number_mission
  belongs_to :author, class_name: "User", optional: true  
  belongs_to :control_executor, class_name: "User", optional: true
  belongs_to :mission_type, optional: true
  belongs_to :division, optional: true
  counter_culture :mission_type
  counter_culture :author, column_name: "author_tasks_count"
  counter_culture :control_executor, column_name: "executor_tasks_count"

  has_many :mission_executors, dependent: :destroy
  has_many :completed_missions, dependent: :destroy, through: :mission_executors, foreign_key: :mission_id
  has_many :mission_approvals, dependent: :destroy

  validates :author_id, :control_executor_id, :mission_type_id, 
            :description, presence: true


  def looked!
    unless self.read_at.present?
      self.read_at = DateTime.now
      self.status = :in_work
      self.save!
    end
  end

  def get_status_user(user)
    self.mission_executors.where(executor: user).pluck(:status)
  end

  private

  def set_number_mission
    if self.new_record?
      Mission.last.present? ? mission_number = Mission.last.id + 1 : mission_number = 1
      mission_type = MissionType.find(self.mission_type_id)    
      self.number = "#{mission_number}/#{mission_type.name[0, 1].upcase}-#{Date.today.year}" 
    end
  end
end
