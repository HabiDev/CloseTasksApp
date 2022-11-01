module CompletedTasksHelper
  def completed_info(completed_task)
    unless current_user.user?
      "#{completed_task.user.profile.full_name}, #{l(completed_task.created_at, format: :full)}"
    end
  end

  def time_task(completed_task)    
    t(distance_of_time_in_words(completed_task.time_start, completed_task.time_end)) +
    " (#{l(completed_task.time_start, format: :mini)}-#{l(completed_task.time_end, format: :mini)})"    
  end

  def completed_tasks_count(resource)    
    resource.completed_tasks_count if resource.completed_tasks_count > 0
  end
end
