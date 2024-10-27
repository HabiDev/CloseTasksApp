class RelatedMission < ApplicationRecord
  belongs_to :mission

  validates :mission_id, :related, presence: true

end
