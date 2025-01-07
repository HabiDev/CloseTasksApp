class User < ApplicationRecord 
  enum type_role: { user: 0, guide: 1, admin: 3, moderator: 4 }

  belongs_to :manager, class_name: "User", optional: true
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :registerable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :rememberable, :validatable, :lockable, 
         :trackable, :timeoutable, :recoverable

  has_one :profile, dependent: :destroy
  has_many :completed_tasks, dependent: :destroy
  has_many :author_tasks, class_name: "Task", foreign_key: "author_id", dependent: :destroy
  has_many :executor_tasks, class_name: "Task", foreign_key: "executor_id", dependent: :destroy
  has_many :author_check_lists, class_name: "CheckList", foreign_key: "author_id", dependent: :destroy
  has_many :tasks, class_name: "Task", foreign_key: "author_id", inverse_of: 'author'
  has_many :check_lists, class_name: "CheckList", foreign_key: "author_id", inverse_of: 'author'

  has_many :author_missions, class_name: "Mission", foreign_key: "author_id", dependent: :destroy
  has_many :control_executor_missions, class_name: "Mission", foreign_key: "executor_id", dependent: :destroy
  has_many :missions, class_name: "Mission", foreign_key: "author_id", inverse_of: 'author'
  has_many :subordinates, class_name: "User", foreign_key: "manager_id"
  has_many :mission_executors, class_name: "MissionExecutor", foreign_key: "executor_id", dependent: :destroy
  has_many :mission_approvals, class_name: "MissionApproval", foreign_key: "coordinator_id", dependent: :destroy

  has_one :sub_department, through: :profile

  delegate :full_name, to: :profile
  
  accepts_nested_attributes_for :profile, allow_destroy: true

  # broadcasts_to ->(user) { "users" }, inserts_by: :prepend
  
  default_scope { joins(:profile).order(full_name: :asc) }

  scope :list_all, ->(current_user) { where.not(id: current_user).where(locked_at: nil) }  
  scope :control_user, ->(current_user) { where(manager: current_user.manager).or(where(manager: current_user)).or(where(id: current_user)).and(where(locked_at: nil)) }
  scope :moderator_control_user, ->(current_user) { where(manager: current_user.manager).or(where(id: current_user)).and(where(locked_at: nil)) }
  scope :executor_users, ->(current_user) { where(manager: current_user.manager)
                                            # .or(where(manager: current_user.manager))
                                            .and(where(locked_at: nil))
                                            .or(where(id: current_user)) 
                                          }
  scope :executor_users_yours, ->(current_user) { where(manager: current_user)
                                                  .and(where(locked_at: nil))
                                                  .or(where(id: current_user)) 
                                                }
  scope :moderator_executor_users, ->(current_user) { where(manager: current_user.manager)
                                                      .and(where(locked_at: nil))
                                                      .and(where.not(id: current_user)) 
                                                    }
  scope :except_control_on_author, ->(author, control_executor) {  where.not(id: author)
                                                                   .and(where.not(id: control_executor))
                                                                }
  scope :except_author, ->(author) {  where.not(id: author) }
  scope :except_mission_executors, ->(executor_ids) { where.not(id: executor_ids) }

  scope :sub_department_user, ->(sub_department) { joins(:profile).where(profile: { sub_department_id: sub_department }) }

  # def full_name
  #   self.profile.full_name
  # end

  def male?
    self.profile.male?
  end

  def female?
    self.profile.female?
  end

  def author_of?(resource)
    self.id == resource.author_id
  end
  
  def executor_of?(resource)
    self.id == resource.executor_id
  end

  def control_executor_of?(resource)
    self.id == resource.control_executor_id
  end

  def coordinator_of?(resource)
    self.id == resource.coordinator_id
  end

  def manager_of?(resource)
    self.id == resource.executor.manager_id
  end


  def subordinates_of?(user)
    self.subordinates.include?(user)
  end
  
end
