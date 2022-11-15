class Position < ApplicationRecord
  has_many :profiles, dependent: :destroy

  default_scope { order(name: :asc) }
end
