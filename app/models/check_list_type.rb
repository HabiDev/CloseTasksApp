class CheckListType < ApplicationRecord
  has_many :sub_check_lists, dependent: :destroy
  has_many :check_lists, dependent: :destroy

  validates :name, presence: true

  default_scope { order(name: :asc) }
end
