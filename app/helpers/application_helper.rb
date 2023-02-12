module ApplicationHelper
  ALERTS = { alert: 'warning', 
             notice: 'info',
             success: 'success',
             error: 'danger' }.freeze

  def alert_manager(key)
    ALERTS[key.to_sym] || key
  end

  def mobile_device?
    agent = request.user_agent
    return true if agent =~ /Mobile/
  end

end
