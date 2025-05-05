module UsersHelper
  def current_sign_in_at(user)
    # caption = t("caption.current_sign_in")
    # if user.current_sign_in_at.present?
    #   "#{caption}: #{user.current_sign_in_at}"
    # else
    #   "#{caption}:"
    # end  
    l(user.current_sign_in_at, format: :full) if user.current_sign_in_at.present?
  end

  def last_sign_in_at(user)
    # caption = t("caption.last_sign_in")
    # if user.last_sign_in_at.present?
    #   "#{caption}: #{user.last_sign_in_at}"
    # else
    #   "#{caption}:"
    # end  
    l(user.last_sign_in_at, format: :full) if user.last_sign_in_at.present?
  end

  def role_user(user)
    case user.type_role
    when "guide"
      content_tag(:span, "#{enum_l(user, :type_role)}", class: "badge bg-primary")
    when "admin"
      content_tag(:span, "#{enum_l(user, :type_role)}", class: "badge bg-warning")
    when "moderator"
      content_tag(:span, "#{enum_l(user, :type_role)}", class: "badge bg-info")
    else
      content_tag(:span, "#{enum_l(user, :type_role)}", class: "badge bg-success")
    end
  end

  def locked_at(user)
    content_tag(:span, content_tag(:i, "", class: "bi bi-lock-fill text-danger")) if user.locked_at.present?
  end

  def manager(user)
    content_tag(:span, content_tag(:i, "", class: "bi bi-star-fill text-warning")) if user.subordinates.present?
  end

end
