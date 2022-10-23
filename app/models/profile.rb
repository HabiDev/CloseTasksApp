class Profile < ApplicationRecord
  belongs_to :user
  belongs_to :sub_department, class_name: 'SubDepartment', foreign_key: :sub_department_id
  belongs_to :position
  counter_culture :sub_department
  counter_culture :position


  validates :full_name, :mobile, :sub_department_id, :position_id, presence: true

  scope :default, -> { order(full_name: :asc) }

end
