class SubCategory < ApplicationRecord
  belongs_to :category, optional: true

  validates :name, presence: true
end
