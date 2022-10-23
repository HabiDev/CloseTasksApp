class Position < ApplicationRecord
  has_many :profiles, dependent: :destroy

end
