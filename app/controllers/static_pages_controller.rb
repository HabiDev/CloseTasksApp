class StaticPagesController < ApplicationController
  before_action :authenticate_user!

  def home
    if current_user.admin?
      redirect_to admin_root_path
    else
      redirect_to root_path
    end
  end
end
