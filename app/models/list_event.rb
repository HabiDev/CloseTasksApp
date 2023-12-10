class ListEvent < ApplicationRecord
  belongs_to :check_list, optional: true
  belongs_to :sub_check_list, optional: true

  has_many :tasks, dependent: :destroy

  validates :check_list_id, :sub_check_list_id, presence: true

  default_scope { order(created_at: :asc) }

  scope :processed, -> { where.not(check_status: 2).count }

  scope :not_processed, -> { where.not(check_status: 1).count }
  
end
