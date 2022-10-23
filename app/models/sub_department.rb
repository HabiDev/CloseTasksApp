class SubDepartment < ApplicationRecord
  belongs_to :department, optional: true
  has_many :profiles, dependent: :destroy
  counter_culture :department

  validates :name, presence: true

  scope :default, -> { order(name: :asc) }
end
