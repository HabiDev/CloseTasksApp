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
  
end
