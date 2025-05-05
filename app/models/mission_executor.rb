class MissionExecutor < ApplicationRecord
  attr_accessor :new_deadline

  before_save :save_of_day
  before_create :notify_user_of_new_task
  before_update :notify_user_of_status_change

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
      self.errors.add(:new_deadline, :date_more)
      return false
    end

    if coordinator.present?
      if (coordinator.executor_id == self.executor_id) && (new_date.to_date > self.mission.execution_limit_at.to_date)
        self.errors.add(:new_deadline, :date_more)
        return false
      elsif (coordinator.executor_id != self.executor_id) && (new_date.to_date >= coordinator.limit_at.to_date)
        self.errors.add(:new_deadline, :date_more)
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

  def save_of_day
    self.limit_at = self.limit_at.end_of_day if self.limit_at.present?
    self.close_at = self.close_at.end_of_day if self.close_at.present?
  end

  def executor_has_telegram_id?
    self.executor.telegram_id.present?
  end

  def notify_user_of_new_task
    return unless executor_has_telegram_id?

    text = "У Вас новое задание: \n#{self.description}\nСрок исполнения: #{I18n.l(self.limit_at, format: :small)}"
    send_telegramm(executor.telegram_id, text)
  end

  def notify_user_of_status_change
    return unless executor_has_telegram_id?

    return if registred? || in_work? || in_approval?

    text = "У Вашего задания: \n#{self.description}\nИзменился статус на: '#{self.human_enum_name(:status, self.status)}'"
    send_telegramm(executor.telegram_id, text)
  end

end
