class Profile < ApplicationRecord
  enum gender: { male: 0, female: 1 }

  belongs_to :user
  belongs_to :sub_department, class_name: 'SubDepartment', foreign_key: :sub_department_id
  belongs_to :position
  counter_culture :sub_department
  counter_culture :position


  validates :full_name, :mobile, :sub_department_id, :position_id, presence: true

  default_scope { order(full_name: :asc) }

end
