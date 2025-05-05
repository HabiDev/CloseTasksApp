class MissionApproval < ApplicationRecord
  belongs_to :mission
  belongs_to :coordinator, class_name: "User", optional: true

  before_create :notify_user_of_new_approval

  private

  def notify_user_of_new_approval
    text = "Вам поступило инфромация для согласования"
    send_telegramm(self.coordinator.telegram_id, text) if self.coordinator.telegram_id.present?    
  end
end
