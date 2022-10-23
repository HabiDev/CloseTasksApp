class Category < ApplicationRecord
  has_many :sub_categories, dependent: :destroy

  validates :name, presence: true

  scope :default, -> { order(name: :asc) }
end
