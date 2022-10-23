class Profile < ApplicationRecord
  belongs_to :user
  belongs_to :sub_department, class_name: 'SubDepartment', foreign_key: :sub_department_id
  belongs_to :position

  validates :full_name, :mobile, :sub_department_id, :position_id, presence: true

end
