module PerformedWorksHelper
  def performed_info(resource)
    "#{l(resource.created_at, format: :full)} "
    # unless current_user.user?
    #   "#{resource.user.profile.full_name}, #{l(resource.created_at, format: :full)}"
    # end
  end

  def time_work(resource)    
    t(distance_of_time_in_words(resource.time_start, resource.time_end)) +
    " (#{l(resource.time_start, format: :mini)}-#{l(resource.time_end, format: :mini)})"    
  end

  def performed_works_count(resource)    
    resource.performed_works_count if resource.performed_works_count > 0
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