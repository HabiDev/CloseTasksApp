module UsersHelper
  def current_sign_in_at(user)
    caption = t("caption.current_sign_in")
    if user.current_sign_in_at.present?
      "#{caption}: #{user.current_sign_in_at}"
    else
      "#{caption}:"
    end  
  end

  def last_sign_in_at(user)
    caption = t("caption.last_sign_in")
    if user.last_sign_in_at.present?
      "#{caption}: #{user.last_sign_in_at}"
    else
      "#{caption}:"
    end  
  end
end
