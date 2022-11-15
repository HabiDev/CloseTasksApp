class Department < ApplicationRecord
  has_many :profiles, dependent: :destroy
  has_many :sub_departments, dependent: :destroy

  default_scope { order(name: :asc) }
end
