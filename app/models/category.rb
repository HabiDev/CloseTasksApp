class Category < ApplicationRecord
  has_many :sub_categories, dependent: :destroy

  validates :name, presence: true

  default_scope { order(name: :asc) }
end
