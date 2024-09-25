module ApplicationHelper
  include Pagy::Frontend

  ALERTS = { alert: 'warning', 
             notice: 'info',
             success: 'success',
             error: 'danger' }.freeze
  
  def alert_manager(key)
    ALERTS[key.to_sym] || key
  end

  def title_info(resource)
    "#{l(resource.created_at, format: :full)} "
    # unless current_user.user?
    #   "#{resource.user.profile.full_name}, #{l(resource.created_at, format: :full)}"
    # end
  end

  def flash_class(level)
    case level
      when 'notice' then "alert alert-info"
      when 'success' then "alert alert-success"
      when 'error' then "alert alert-danger"
      when 'alert' then "alert alert-warning"
      when 'danger' then "alert alert-danger"
      when 'warning' then "alert alert-warning"
    end
  end

  def render_turbo_stream_flash_messages
    turbo_stream.prepend "flash", partial: "shared/flash"
  end
  
  def show_badge(resource)    
    tag(:span, class: "position-absolute top-0 start-100 translate-middle p-2 bg-danger border border-light rounded-circle") if resource.present?
    # tag("span", class: ["position-absolute", "top-0", "start-100", "translate-middle", "p-2", "bg-danger", "border", "border-light", "rounded-circle"])
  end 

  
end
