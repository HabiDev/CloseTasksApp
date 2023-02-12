class ApplicationController < ActionController::Base  
  include Pagy::Backend  

  helper_method :mobile_device?

  protect_from_forgery with: :exception
  # after_action :home_path

  def after_sign_in_path_for(current_user)
    if current_user.admin?
      admin_root_path
    else
      root_path
    end
  end

  private 

  def home_path
    if current_user&.admin?
      admin_root_path
    else
      root_path
    end
  end

  def mobile_device?
    agent = request.user_agent
    return true if agent =~ /Mobile/
  end

end
