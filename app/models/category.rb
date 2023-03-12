class Category < ApplicationRecord
  has_many :sub_categories, dependent: :destroy
  has_many :tasks, dependent: :destroy
  belongs_to :priority, optional: true
  

  validates :name, :priority, presence: true

  default_scope { order(name: :asc) }
end
