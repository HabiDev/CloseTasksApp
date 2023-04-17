module MissionExecutorsHelper
  def mission_executor_info(resource)
    if resource.limit_at.present?
      "#{resource.executor.full_name}, срок исп. - #{l(resource.created_at, format: :full)}"
    else
      "#{resource.executor.full_name}"
    end
    # unless current_user.user?
    #   "#{resource.user.profile.full_name}, #{l(resource.created_at, format: :full)}"
    # end
  end
end