class Division < ApplicationRecord
  belongs_to :department

  validates :name, :email, :department_id, :address, presence: true

  broadcasts_to ->(division) { "divisions" }, inserts_by: :prepend

  scope :ordered, -> { order(name: :asc) }
end
