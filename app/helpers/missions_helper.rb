module MissionsHelper
  STASUS = { registred: 'info',  
             in_work: 'primary', 
             in_approval: 'info', 
             in_rework: 'secondary', 
             agree: 'info', 
             executed: 'success',
             not_executed: 'danger',
             delayed: 'warning',
             canceled: 'dark' }.freeze

  def status_manager(key)
    STASUS[key.to_sym] || key
  end

  def mission_count(resource)    
    resource.tasks_count if resource.tasks_count > 0
  end

  def mission_closed(resource)
    content_tag(:span, "выпол.: #{l(resource.close_at, format: :normal)}", class: 'ps-1 text-secondary') if resource.close_at.present?
  end

  def status_classing(resource)
    # current_user_status = resource.mission_executors.find_by(executor: current_user)
    # if (resource.executed? && resource.close_at.present?) || (resource.canceled? && resource.close_at.present?)
    status_manager(resource.status)
    # elsif current_user_status.present?
    #   status_manager(current_user_status.status)
    # elsif resource.mission_executors.last_status.first.present?
    #   status_manager(resource.mission_executors.last_status.first.status)
    # else
    #   status_manager(resource.status)
    # end
  end

  def executed_mission_status(resource)
    # current_user_status = resource.mission_executors.find_by(executor: current_user)
    if (resource.executed? && resource.close_at.present?) || (resource.canceled? && resource.close_at.present?)
      "#{enum_l(resource, :status)}"
    elsif resource.present?
      enum_l(resource, :status)
    elsif resource.delayed?
      "#{enum_l(resource, :status)}"
    # elsif resource.mission_executors.last_status.first.present?
    #   enum_l(resource.mission_executors.last_status.first, :status)
    else
      enum_l(resource, :status)
    end
  end

  # def show_badge(resource)    
  #   tag(:span, class: "fa-stack fa-5x has-badge") if resource.exists?
  # end 

  def class_priority(resource)
    if resource.high? 
      "warning"
    elsif resource.rush?   
      "danger"
    else
     "info" 
    end
  end

  def class_mission(resource)
    if resource.execution_limit_at.present? && !resource.canceled?
      if (Date.today > resource.execution_limit_at) 
        "danger"
      elsif (Date.today == resource.execution_limit_at) 
        "warning" 
      elsif resource.delayed?
        "info"
      else
        "primary"
      end 
    elsif resource.canceled?
      "default"
    else
      "success"
    end

  end

  def mission_executed_at(resource)
    if !resource.close_at.present? && resource.execution_limit_at.present?
      if (Date.today.beginning_of_day < resource.execution_limit_at.end_of_day)
        content_tag(:small, "#{'Срок исп.: '}" + "#{l(resource.execution_limit_at, format: :normal)}", class: 'text-success')
      elsif (Date.today.beginning_of_day > resource.execution_limit_at.end_of_day)
        content_tag(:small, "#{'Срок исп.: '}" + "#{l(resource.execution_limit_at, format: :normal)}", class: 'text-danger')
      elsif (resource.execution_limit_at.beginning_of_day - Date.today.end_of_day).to_i <= 1 
        content_tag(:small, "#{'Срок исп.: '}" + "#{l(resource.execution_limit_at, format: :normal)}", class: 'text-warning')
      end
    end        
  end

  def detlain_executed_at(resource)
    if !resource.close_at.present? && resource.execution_limit_at.present?
      if (Date.today.beginning_of_day < resource.execution_limit_at.end_of_day)
        content_tag(:span, "срок: #{l(resource.execution_limit_at, format: :normal)}", class: 'text-success')
      elsif (Date.today.beginning_of_day > resource.execution_limit_at.end_of_day)
        content_tag(:span, "срок: #{l(resource.execution_limit_at, format: :normal)}", class: 'text-danger')
      elsif (resource.execution_limit_at.beginning_of_day - Date.today.end_of_day).to_i <= 1 
        content_tag(:span, "срок: #{l(resource.execution_limit_at, format: :normal)}", class: 'text-warning')
      end
    end        
  end

  def mission_execution_limited(resource)    
    if !resource.close_at.present? && resource.execution_limit_at.present?
      if (Date.today.beginning_of_day < resource.execution_limit_at.end_of_day)
        content_tag(:small, "(осталось: #{distance_of_time_in_words(Date.today.beginning_of_day, resource.execution_limit_at.end_of_day)})",
          class: 'text-success')
      elsif (Date.today.beginning_of_day > resource.execution_limit_at.end_of_day)
        content_tag(:small, "(просрочено: #{distance_of_time_in_words(Date.today, resource.execution_limit_at)})",
          class: 'text-danger')
      end
    elsif resource.close_at.present?
      if (resource.close_at.beginning_of_day < resource.execution_limit_at.end_of_day)
        content_tag(:small, "(выпол. за: #{distance_of_time_in_words(resource.close_at, resource.execution_limit_at)})",
          class: 'text-success')
      elsif (resource.close_at.beginning_of_day > resource.execution_limit_at.end_of_day)
        content_tag(:small, "(прочрочено на: #{distance_of_time_in_words(resource.close_at, resource.execution_limit_at)})",
          class: 'text-danger')
      end
    end 
  end

end

