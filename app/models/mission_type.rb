class MissionType < ApplicationRecord
  has_many :missions, dependent: :destroy
 
  validates :name, presence: true

  default_scope { order(name: :asc) }

  def normal?
    self.id == 3
  end

  def high?
    self.id == 2
  end

  def rush?
    self.id == 1
  end
end
