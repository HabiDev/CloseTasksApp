module MissionExecutorsHelper
  def mission_executor_info(resource)
    if resource.limit_at.present? && !resource.close_at.present? 
      "Срок исп. - #{l(resource.limit_at, format: :normal)}, статус: #{enum_l(resource, :status)}"
    elsif resource.close_at.present?
      "(Срок исп. - #{l(resource.limit_at, format: :normal)}) Снять с контроля - #{l(resource.close_at, format: :normal)}"
    elsif !resource.mission.execution_limit_at.present?
      "Нет контроля(только для информации)"
    end
    # unless current_user.user?
    #   "#{resource.user.profile.full_name}, #{l(resource.created_at, format: :full)}"
    # end
  end

  def mission_executor_status(resource)
    if resource.limit_at.present? && !resource.close_at.present? 
      content_tag(:span, "#{enum_l(resource, :status)}", class: "text-#{status_class(resource)} ps-1")
    elsif resource.close_at.present? 
      if resource.agree?
        content_tag(:span, "Исполнено(#{enum_l(resource, :status)}), Снять с контроля - #{l(resource.close_at, format: :normal)}", class: "text-#{status_class(resource)} ps-1")
      else
        content_tag(:span, "#{enum_l(resource, :status)}, Снять с контроля - #{l(resource.close_at, format: :normal)}", class: "text-#{status_class(resource)} ps-1")
      end
    elsif !resource.mission.execution_limit_at.present?
      content_tag(:span, "Нет контроля(только для информации)")
    end
  end

  def status_class(resource)
    return "primary" if resource.in_work?
    return "agree" if resource.in_approval? 
    return "secandary" if resource.canceled?     
    return "warning" if resource.in_rework? 
    return "success" if resource.agree? || resource.executed?
  end

  def mission_executor_executed_at(resource)
    if !resource.close_at.present? && resource.limit_at.present?
      if (Date.today.end_of_day < resource.limit_at.end_of_day) && ((resource.limit_at.end_of_day - Date.today.end_of_day).to_i) >= 1
        content_tag(:span, "#{'Срок исп.: '}" + "#{l(resource.limit_at, format: :normal)}", class: 'ps-1 text-success')
      elsif (Date.today.end_of_day > resource.limit_at.end_of_day)
        content_tag(:span, "#{'Срок исп.: '}" + "#{l(resource.limit_at, format: :normal)}", class: 'ps-1 text-danger')
      elsif ((resource.limit_at.end_of_day - Date.today.end_of_day).to_i) <= 1
        content_tag(:span, "#{'Срок исп.: '}" + "#{l(resource.limit_at, format: :normal)}", class: 'ps-1 text-warning')
      end
    elsif resource.limit_at.present?
      content_tag(:span, "#{'Срок исп.: '}" + "#{l(resource.limit_at, format: :normal)}", class: 'ps-1 text-secondary')
    end        
  end

  def detlain_executor_executed_at(resource)
    if !resource.close_at.present? && resource.limit_at.present?
      if (Date.today.end_of_day < resource.limit_at.end_of_day) && ((resource.limit_at.end_of_day - Date.today.end_of_day).to_i) >= 1
        content_tag(:span, "срок: #{l(resource.limit_at, format: :normal)}", class: 'ps-1 text-success')
      elsif (Date.today.end_of_day > resource.limit_at.end_of_day)
        content_tag(:span,  "срок: #{l(resource.limit_at, format: :normal)}", class: 'ps-1 text-danger')
      elsif ((resource.limit_at.end_of_day - Date.today.end_of_day).to_i) <= 1
        content_tag(:span, "срок: #{l(resource.limit_at, format: :normal)}", class: 'ps-1 text-warning')
      end
    elsif resource.limit_at.present?
      content_tag(:span, "срок: #{l(resource.limit_at, format: :normal)}", class: 'ps-1 text-secondary')
    end        
  end

  def executor_responsible(resource)
    if resource.responsible
      "#{resource.executor.full_name} - Ответственный" 
    else
      "#{resource.executor.full_name}"
    end
  end

  def mission_executor_limited(resource)    
    if !resource.close_at.present? && resource.limit_at.present?
      if (Date.today.beginning_of_day < resource.limit_at.end_of_day)
        content_tag(:span, "(осталось: #{distance_of_time_in_words(Date.today.beginning_of_day, resource.limit_at.end_of_day)})",
          class: 'text-success ps-1')
      elsif (Date.today.beginning_of_day > resource.limit_at.end_of_day)
        content_tag(:span, "(просрочено: #{distance_of_time_in_words(Date.today.beginning_of_day, resource.limit_at.end_of_day)})",
          class: 'text-danger ps-1')
      end
    elsif resource.close_at.present?
      if (resource.close_at.beginning_of_day < resource.limit_at.end_of_day)
        content_tag(:span, "(выпол.: #{distance_of_time_in_words(resource.close_at.beginning_of_day, resource.limit_at.end_of_day)})",
          class: 'text-success ps-1')
      elsif (resource.close_at.beginning_of_day > resource.limit_at.end_of_day)
        content_tag(:span, "(просрочено: #{distance_of_time_in_words(resource.close_at.beginning_of_day, resource.limit_at.end_of_day)})",
          class: 'text-danger ps-1')
      end
    end 
  end
end