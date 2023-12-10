class CheckListGroup < ApplicationRecord
  has_many :sub_check_list, dependent: :destroy
 
  validates :name, presence: true

  default_scope { order(name: :asc) }

end
