class SubCategory < ApplicationRecord
  belongs_to :category, optional: true
  has_many :completed_tasks, dependent: :destroy
  counter_culture :category

  validates :name, presence: true

  default_scope { order(name: :asc) }
end
