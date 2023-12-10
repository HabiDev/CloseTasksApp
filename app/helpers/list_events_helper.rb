module ListEventsHelper

  def check_status_manager(key)
    if key == 0
      "danger"
    elsif key == 1
      "success"
    else
      "secondary"
    end
  end

  def check_callout(key)
    if key == 0
      "danger"
    elsif key == 1
      "info"
    else
      "default"
    end
  end

  def check_status_icon(key)
    if key == 0
      "bi bi-x-square"
    elsif key == 1
      "bi bi-check-square"
    else
      "bi bi-square"
    end
  end



end

