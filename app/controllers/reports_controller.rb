class ReportsController < ApplicationController
  before_action :authenticate_user!

  def index
    
  end

  def report_all_count
    @date_start = params[:date_start]&.to_datetime
    @date_end = params[:date_end]&.to_datetime
    @tasks = Task.date_between(@date_start, @date_end)
    @performed_works = PerformedWork.date_between(@date_start, @date_end)
    @completed_tasks = CompletedTask.date_between(@date_start, @date_end)

    @sub_category_completed_tasks = @completed_tasks.sub_category_completed_tasks
    @sub_category_tasks = @performed_works.sub_category_tasks
    @all_sub_category_tasks = @sub_category_completed_tasks.merge( @sub_category_tasks) { |key, val1, val2| val1+val2 }

    @users = User.includes(:profile).where(id: (@tasks.pluck(:executor_id).uniq))
             .or(User.where(id: (@completed_tasks.pluck(:user_id).uniq))).order('profile.full_name asc')

    respond_to do |format|
      format.html
      format.xlsx
    end
  end

  private

  def reports_params
    params.require(:reports).permit(:date_start, :date_end)
  end

end