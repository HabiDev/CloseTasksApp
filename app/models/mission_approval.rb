class MissionApproval < ApplicationRecord
  belongs_to :mission
  belongs_to :coordinator, class_name: "User", optional: true
end
