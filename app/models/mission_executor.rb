class MissionExecutor < ApplicationRecord
  attr_accessor :new_deadline

  before_save :save_of_day
  before_create :notify_new_task
  before_update :notify_change

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
  
  has_many_attached :app_files
  belongs_to :mission
  belongs_to :executor, class_name: "User", optional: true
  counter_culture :mission
  counter_culture :executor, column_name: "executor_missions_count"

  has_many :completed_missions, dependent: :destroy

  validates :mission_id, :executor_id, :parent_executor_id, :description, presence: true

  validate :limit_at_cannot_exceed_mission_limit

  default_scope { order(parent_executor_id: :asc) }

  scope :last_status, ->{ order(updated_at: :desc) }

  scope :executor_mission, ->(current_user) { where(executor_id: current_user) }

  scope :parent_executor_mission, ->(parent_user) { where(parent_executor_id: parent_user) }

  scope :responsible_mission, ->{ where(responsible: true)}

  scope :opened, ->(current_user) { joins(:mission).where.not(mission: { control_executor: current_user } ).where(close_at: nil) }

  def mission_looked!
    unless self.read_at.present?
      self.read_at = DateTime.now
      self.status = :in_work
      self.save!
      if self.mission.registred?
        self.mission.status = :in_work
        self.mission.save
      end
    end
  end

  def self.parent_for_executor(mission)
    MissionExecutor.includes(executor: :profile).where("mission_id = ? and parent_executor_id = 0", mission).order(["responsible DESC", "limit_at ASC", "profiles_users.full_name ASC"])
  end

  def self.replies_for_executor(mission)
    MissionExecutor.where("mission_id = ? and parent_executor_id != 0", mission).order(["executor_id", "id"]).group_by {|mission_executor| mission_executor["parent_executor_id"] }
  end

  def parent_executor(mission, parent)
    MissionExecutor.where("mission_id = ? and executor_id = ?", mission, parent)
  end

  def coordinator_executor(mission, coordinator)
    MissionExecutor.where("mission_id = ? and executor_id = ?", mission, coordinator)
  end

  def valid_date_deadline?(new_date)
    coordinator = coordinator_executor(self.mission_id, self.coordinator_id).first
    parent = parent_executor(self.mission_id, self.parent_executor_id).first

    if new_date.blank?
      self.errors.add(:new_deadline, :date_empty)
      return false
    end

    if (new_date.to_date == self.limit_at.to_date) || (new_date.to_date <= self.mission.created_at.to_date)
      self.errors.add(:new_deadline, :date_less)
      return false
    end

    if parent.present? && new_date.to_date >= parent.limit_at.to_date
      self.errors.add(:new_deadline, :date_more_parrent)
      return false
    end

    if coordinator.present?
      if (coordinator.executor_id == self.executor_id) && (new_date.to_date > self.mission.execution_limit_at.to_date)
        self.errors.add(:new_deadline, :date_more)
        return false
      elsif (coordinator.executor_id != self.executor_id) && (new_date.to_date >= coordinator.limit_at.to_date)
        self.errors.add(:new_deadline, :date_more_coordinator)
        return false
      end
    end

    if (new_date.to_date >= self.mission.execution_limit_at.to_date)
      self.errors.add(:new_deadline, :date_more)
      return false
    end

    return true
  end

  private

  def limit_at_cannot_exceed_mission_limit
    if limit_at && mission && limit_at > mission.execution_limit_at
      errors.add(:limit_at, :date_more_mission)
    end
  end

  def save_of_day
    self.limit_at = self.limit_at.end_of_day if self.limit_at.present?
    self.close_at = self.close_at.end_of_day if self.close_at.present?
  end

  def notify_new_task
    text = "У Вас новое задание: \n#{description}\nСрок исполнения: #{I18n.l(limit_at, format: :small)}"
    TelegramNotifier.new(executor).notify(text)
  end
  
  def notify_change
    return if registred? || in_approval?
    return unless executor&.telegram_id.present?

    text = if limit_at_changed?
            "У Вашего задания:\n#{description}\nИзменён срок исполнения: #{I18n.l(limit_at, format: :small)}"
           else
            "У Вашего задания:\n#{description}\nИзменился статус на: '#{human_enum_name(:status, status)}'"
           end
    TelegramNotifier.new(executor).notify(text)
  end

end
