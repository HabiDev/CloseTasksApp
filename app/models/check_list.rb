class CheckList < ApplicationRecord
  belongs_to :division
  belongs_to :check_list_type
  belongs_to :author, class_name: "User", optional: true

  has_many :list_events, dependent: :destroy

  validates :division_id, :check_list_type_id, :author_id, presence: true

  default_scope { order(created_at: :desc) }

end
