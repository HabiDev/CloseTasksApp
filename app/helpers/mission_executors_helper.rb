module MissionExecutorsHelper
  def mission_executor_info(resource)
    if resource.limit_at.present? && !resource.close_at.present? 
      "#{resource.executor.full_name}, срок исп. - #{l(resource.limit_at, format: :normal)}, статус: #{enum_l(resource, :status)}"
    elsif resource.close_at.present?
      "#{resource.executor.full_name}, снять с контроля - #{l(resource.close_at, format: :normal)}"
    elsif !resource.mission.execution_limit_at.present?
      "#{resource.executor.full_name}, Нет контроля(только для информации)"
    end
    # unless current_user.user?
    #   "#{resource.user.profile.full_name}, #{l(resource.created_at, format: :full)}"
    # end
  end
end