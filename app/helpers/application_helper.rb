module ApplicationHelper
  ALERTS = { alert: 'warning', 
             notice: 'info',
             success: 'success',
             error: 'danger' }.freeze

  def alert_manager(key)
    ALERTS[key.to_sym] || key
  end

end
