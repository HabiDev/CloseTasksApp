class Position < ApplicationRecord
  has_many :profiles, dependent: :destroy

  scope :default, -> { order(name: :asc) }
end
