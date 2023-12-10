class SubCheckList < ApplicationRecord
  belongs_to :check_list_type
  belongs_to :check_list_group

  has_many :list_events, dependent: :destroy

  validates :name, presence: true

  default_scope { order(check_list_type_id: :asc, check_list_group_id: :asc, name: :asc) }

  scope :type_lists, ->(list_type) { where(check_list_type_id: list_type) }
end
