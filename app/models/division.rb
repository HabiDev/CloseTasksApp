class Division < ApplicationRecord
  belongs_to :department
  has_many :completed_tasks, dependent: :destroy
  has_many :check_lists, dependent: :destroy
  has_many :missions, dependent: :destroy

  counter_culture :department

  validates :name, :email, :department_id, :address, presence: true

  # broadcasts_to ->(division) { "divisions" }, inserts_by: :prepend

  default_scope { order(name: :asc) }

  scope :ordered, -> { order(name: :asc) }

  scope :list_active, -> { where(active: true) }
end
