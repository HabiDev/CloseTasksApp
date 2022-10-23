class SubDepartment < ApplicationRecord
  belongs_to :department, optional: true

  validates :name, presence: true
end
