class Department < ApplicationRecord
  has_many :profiles, dependent: :destroy
  has_many :sub_departments, dependent: :destroy

  scope :default, -> { order(name: :asc) }
end
