class User < ApplicationRecord 
  enum type_role: { user: 0, guide: 1, admin: 3, moderator: 4 }
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :registerable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :rememberable, :validatable, :lockable, 
         :trackable, :timeoutable

  has_one :profile, dependent: :destroy
  has_many :completed_tasks, dependent: :destroy
  has_many :author_tasks, class_name: "Task", foreign_key: "author_id", dependent: :destroy
  has_many :executor_tasks, class_name: "Task", foreign_key: "executor_id", dependent: :destroy
  has_many :tasks, class_name: "Task", foreign_key: "author_id", inverse_of: 'author'
  # has_many :tasks, class_name: "Task", foreign_key: "executor_id", inverse_of: 'executor'

  accepts_nested_attributes_for :profile, allow_destroy: true

  # broadcasts_to ->(user) { "users" }, inserts_by: :prepend

  scope :list_all, ->(current_user) { where.not(id: current_user.id) }  

  def full_name
    self.profile.full_name
  end

  def author_of?(resource)
    self.id == resource.author_id
  end
  
  def executor_of?(resource)
    self.id == resource.executor_id
  end
end
