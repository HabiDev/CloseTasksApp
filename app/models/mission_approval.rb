class MissionApproval < ApplicationRecord
  belongs_to :mission
  belongs_to :coordinator, class_name: "User", optional: true

  before_create :notify_user_of_new_approval

  private

  def notify_user_of_new_approval
    text = "Вам поступила инфромация для согласования"
    TelegramNotifier.new(self.coordinator).notify(text) 
  end
end
