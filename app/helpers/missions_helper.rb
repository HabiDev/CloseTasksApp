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

  def status_classing(resource)
    current_user_status = resource.mission_executors.find_by(executor: current_user)
    if (resource.executed? && resource.close_at.present?) || (resource.canceled? && resource.close_at.present?)
      status_manager(resource.status)
    elsif current_user_status.present?
      status_manager(current_user_status.status)
    elsif resource.mission_executors.last_status.first.present?
      status_manager(resource.mission_executors.last_status.first.status)
    else
      status_manager(resource.status)
    end
  end

  def executed_mission_status(resource)
    current_user_status = resource.mission_executors.find_by(executor: current_user)
    if (resource.executed? && resource.close_at.present?) || (resource.canceled? && resource.close_at.present?)
      "#{enum_l(resource, :status)} (#{l(resource.close_at, format: :small)})"
    elsif current_user_status.present?
      enum_l(current_user_status, :status)
    elsif resource.delayed?
      "#{enum_l(resource, :status)} (#{l(resource.execution_limit_at, format: :small)})"
    elsif resource.mission_executors.last_status.first.present?
      enum_l(resource.mission_executors.last_status.first, :status)
    else
      enum_l(resource, :status)
    end
  end

  def show_badge(resource)    
    tag(:span, class: "fa-stack fa-5x has-badge") if resource.exists?
  end 

  def class_priority(resource)
    if resource.high? 
      "warning"
    elsif resource.rush?   
      "danger"
    else
     "info" 
    end
  end

end

