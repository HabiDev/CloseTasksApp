class CompletedTasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_completed_task, except: [ :index, :new, :create, :report_xls]
  
  def index
    # authorize User
    if current_user.user?      
      @q = CompletedTask.includes(:user, :sub_category, :division)
                        .where(user_id: current_user)
                        .created_date(Date.today)
                        .ransack(params[:q])
    else
      @q = CompletedTask.includes(:user, :sub_category, :division).ransack(params[:q])
    end
   
    @q.sorts = ['profile_fullname asc', 'created_at desc'] if @q.sorts.empty?    
    @pagy, @completed_tasks = pagy(@q.result(disinct: true).includes(:user, :sub_category, :division), items: mobile_device? ? 3 : 10)   
    @users = User.all
    @divisions = Division.all
    @categories = SubCategory.all
    @count_completed_tasks = @q.result.count 
    $report_tasks = @q.result(disinct: true).includes(:user, :sub_category, :division) 
    $date_start = params[:q].present? ? params[:q][:created_at_gteq]&.to_datetime : ""
    $date_end = params[:q].present? ? params[:q][:created_at_end_of_day_lteq]&.to_datetime : ""

    # respond_to do |format|
    #   format.html
    #   format.zip { respond_with_zipped_tasks }
    # end
  end

  def new
    # authorize User
    #completed_task = User.new(password: 'UserBlock', password_confirmation: 'UserBlock', locked_at: DateTime.now)
    @completed_task = current_user.completed_tasks.build
  end

  def show
    # authorize completed_task
  end

  def edit
    # authorize completed_task
  end

  def create
    @completed_task = current_user.completed_tasks.build(completed_task_params)    # Not the final implementation!
      # authorize completed_task   
    respond_to do |format|
      if @completed_task.save
        format.html { redirect_to completed_tasks_path, notice: t('notice.record_create') }
        format.turbo_stream { flash.now[:success] = t('notice.record_create') }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    # authorize completed_task    
    respond_to do |format|
      if @completed_task.update(completed_task_params)
        format.html { redirect_to completed_tasks_path, notice: t('notice.record_edit') }
        format.turbo_stream { flash.now[:warning] = t('notice.record_edit') }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    # authorize completed_task
    if @completed_task.destroy
      respond_to do |format|
        format.html { redirect_to completed_tasks_path, notice: t('notice.record_destroy') }
        format.turbo_stream { flash.now[:danger] = t('notice.record_destroy') }
      end
    else
      flash.now[:error] = t('notice.record_destroy_errors')
    end
  end

  def report_xls
    respond_to do |format|
      format.zip { respond_with_zipped_tasks($report_tasks, $date_start, $date_end) }
    end
  end

  private

  def respond_with_zipped_tasks(tasks, date_start, date_end)  
    users = User.includes(:profile).where(id: (tasks.pluck(:user_id).uniq)).order('profile.full_name asc')
    compressed_filestream = Zip::OutputStream.write_buffer do |zos|
      # users.each do |user|
      zos.put_next_entry "task_#{DateTime.now}.xlsx"
      zos.print render_to_string(
        layout: false, handlers: [:axlsx], formats: [:xlsx],
        template: 'completed_tasks/tasks_user',
        locals: { tasks:  tasks, users: users, date_start:  date_start, date_end:  date_end}
      )
      # end
    end
    compressed_filestream.rewind
    send_data compressed_filestream.read, filename: 'report_tasks.zip'    
  end

  def set_completed_task
    @completed_task = CompletedTask.find(params[:id])
  end

  def completed_task_params
    params.require(:completed_task).permit(:division_id, :sub_category_id, :time_start, :time_end, :comment, :workload)
  end
end
