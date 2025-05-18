class CheckAssignmentsDueJob < ApplicationJob
  queue_as :default

  def perform
    today = Date.today.end_of_day
    tomorrow = Date.tomorrow.end_of_day

    # MissionExecutor
    MissionExecutor.where(limit_at: tomorrow, close_at: nil).where.not(status: "in_approval").each do |executor|
      notify(executor, :executor, 'Завтра')
    end

    MissionExecutor.where(limit_at: today, close_at: nil).where.not(status: "in_approval").each do |executor|
      notify(executor, :executor, 'Сегодня')
    end

    # Mission
    Mission.where(execution_limit_at: tomorrow, close_at: nil).each do |mission|
      notify(mission, :control_executor, 'Завтра')
    end

    Mission.where(execution_limit_at: today, close_at: nil).each do |mission|
      notify(mission, :control_executor, 'Сегодня')
    end

    # Task
    Task.where(execution_limit_at: tomorrow, close_at: nil).where.not(status: "in_approval").each do |task|
      notify(task, :control_executor, 'Завтра')
    end

    Task.where(execution_limit_at: today, close_at: nil).where.not(status: "in_approval").each do |task|
      notify(task, :executor, 'Сегодня')
    end
  end

  private

  def notify(entity, user_method, day_text)
    user = entity.send(user_method)
    return unless user&.telegram_id.present?

    text = <<~TEXT
      У Вашего задания:
      #{entity.description}
      #{day_text} наступает срок исполнения!
    TEXT

    entity.send_telegramm(user.telegram_id, text.strip)
    Rails.logger.info "Уведомление отправлено: #{user.telegram_id} (#{entity.class.name} ##{entity.id})"
  rescue => e
    Rails.logger.error "Ошибка при отправке уведомления #{entity.class.name} ##{entity.id}: #{e.message}"
  end
end