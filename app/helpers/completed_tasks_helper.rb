module CompletedTasksHelper
  def completed_info(completed_task)
    unless current_user.user?
      " (#{(t'caption.performer')}: #{completed_task.user.profile.full_name}, #{l(completed_task.created_at, format: :full)})"
    end
  end
end
