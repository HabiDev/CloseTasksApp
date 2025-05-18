class CloseStaleTasksJob < ApplicationJob
  queue_as :default

  def perform
    stale_tasks = Task.where(status: 3)
                      .where('updated_at < ?', 3.days.ago)

    stale_tasks.find_each do |task|
      task.update(status: 6, close_at: Time.current)
    end
  end
end
