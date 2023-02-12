module TasksHelper
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

  def tasks_count(resource)    
    resource.tasks_count if resource.tasks_count > 0
  end

  def executed_status(resource)
    if (resource.executed? && resource.close_at.present?) || (resource.canceled? && resource.close_at.present?)
      "#{enum_l(resource, :status)} (#{l(resource.close_at, format: :small)})"
    else
      enum_l(resource, :status)
    end
  end

  def show_badge(resource)    
    tag(:span, class: "fa-stack fa-5x has-badge") if resource.exists?
  end 
end

