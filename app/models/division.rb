class Division < ApplicationRecord
  belongs_to :department
  has_many :completed_tasks, dependent: :destroy
  counter_culture :department

  validates :name, :email, :department_id, :address, presence: true

  # broadcasts_to ->(division) { "divisions" }, inserts_by: :prepend

  default_scope { order(name: :asc) }

  scope :ordered, -> { order(name: :asc) }
end
