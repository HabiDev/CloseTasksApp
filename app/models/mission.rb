class Mission < ApplicationRecord
  attr_accessor :responsible_executor_id, :new_deadline, :all_recursive

  before_save :save_of_day

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
  
  has_many_attached :app_files
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
  has_many :related_missions, dependent: :destroy

  validates :author_id, :control_executor_id, :mission_type_id, 
            :description, presence: true
  
  alias_attribute :limit_at, :execution_limit_at


  scope :opened, ->(control_user) { where(control_executor_id: control_user).where(close_at: nil) }

  scope :except_related_mission, ->(mission_ids) { where.not(id: mission_ids) }

  scope :overdue, -> { joins(:mission_executors)
                       .where('missions.close_at > missions.execution_limit_at')
                       .or(where('mission_executors.close_at > mission_executors.limit_at'))
                       .or(where(close_at: nil).where('missions.execution_limit_at < ?', Date.today.end_of_day))
                       .distinct 
                     }
  scope :has_executor, ->(executor) { joins(:mission_executors)
                     .where(executor_id: executor)
                   }
  # scope :overdue, -> { joins(:mission_executors)
  #                    .where(:execution_limit_at > :close_at)
  #                    .distinct 
  #                  }


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

  def valid_date_deadline?(new_date)

    if new_date.blank?
      self.errors.add(:new_deadline, :date_empty)
      return false
    end

    if (self.execution_limit_at.present? && new_date.to_date <= self.execution_limit_at.to_date) || (new_date.to_date <= self.created_at.to_date)
      self.errors.add(:new_deadline, :date_less)
      return false
    end

    return true
  end

  def executor_has_mission?(executor)
    mission_executors.where(executor_id: executor).present?
  end

  def author_has_telegram_id?
    self.author.telegram_id.present?
  end

  def control_executor_has_telegram_id?
    self.control_executor.telegram_id.present?
  end

   def build_executor_tree(mission_id)
    # Загружаем всех исполнителей по миссии и группируем по parent_executor_id
    grouped = MissionExecutor
      .where(mission_id: mission_id)
      .order(responsible: :desc, limit_at: :asc)
      .includes(executor: :profile)
      .group_by(&:parent_executor_id)
  
    # Рекурсивно строим дерево
    build_tree_recursive(grouped, 0)
  end
  
  # Рекурсивная сборка дерева
  def build_tree_recursive(grouped, parent_executor_id)
    return [] unless grouped[parent_executor_id]
  
    grouped[parent_executor_id].map do |executor|
      {
        executor: executor,
        children: build_tree_recursive(grouped, executor.executor_id)
      }
    end
  end

  # def extend_deadline(period)
  #   if period.present? && elf.execution_limit_at.present?
  #     day = (period - self.execution_limit_at).to_i
  #     self.execution_limit_at = self.execution_limit_at + day.days
  #     self.save!
  #     self.mission_executors.where(close_at: nil).each do |mission_executor|
  #       mission_executor.limit_at = mission_executor.limit_at + day.days 
  #       mission_executor.save!
  #     end
  #   end
  # end

  private

  def set_number_mission
    if self.new_record?
      Mission.last.present? ? mission_number = Mission.last.id + 1 : mission_number = 1
      mission_type = MissionType.find(self.mission_type_id)    
      self.number = "#{mission_number}/#{mission_type.name[0, 1].upcase}-#{Date.today.year}" 
    end
  end

  def save_of_day
    self.execution_limit_at = self.execution_limit_at.end_of_day if self.execution_limit_at.present?
    self.close_at = self.close_at.end_of_day if self.close_at.present?
  end
end
