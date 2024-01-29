class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, except: [ :index, :new, :create, :report_tasks_xls, :executed_all]
  before_action :set_priority, only: [ :create, :update]
  
  def index
    # authorize User
    if current_user.user?      
      @q = Task.includes(:author, :executor, :priority, :division)
                        .where(author_id: current_user)
                        .or(Task.where(executor_id: current_user))
                        .ransack(params[:q])
    else
      @q = Task.includes(:author, :priority, :division).ransack(params[:q])
    end
    @q.sorts = ['created_at desc', 'priority_id asc', 'division_name asc'] if @q.sorts.empty?
    @pagy, @tasks = pagy(@q.result(disinct: true).includes(:author, :priority, :division), items: mobile_device? ? 3 : 10) 
    # @users = User.all
    # @divisions = Division.all
    # @priorities = Priority.all
    @count_tasks = @q.result.count
    $report_tasks = @q.result(disinct: true).includes(:author, :priority, :division)
    $date_start = params[:q].present? ? params[:q][:created_at_gteq]&.to_datetime : ""
    $date_end = params[:q].present? ? params[:q][:created_at_end_of_day_lteq]&.to_datetime : ""
    @@executed_all = $report_tasks
  end

  def new
    # authorize User
    @task = Task.new   
  end

  def show
    # authorize @division
    @task.looked! unless current_user.author_of?(@task) || !current_user.executor_of?(@task)
    @performed_works = @task.performed_works
  end

  def edit
    # authorize @division   
  end

  def approval
    update_status(status: :in_approval)       
  end

  def canceled
    update_status(status: :canceled, close_at: DateTime.now)
  end

  def rework
   update_status(status: :in_rework)
  end

  def executed
    update_status(status: :executed, close_at: DateTime.now)
  end
 
  def delayed
    update_status(status: :delayed, execution_limit_at: 1.month.since)   
  end  

  def executed_all
    @@executed_all.each do |task|      
        task.update(status: :executed, close_at: DateTime.now) if task.in_approval?
    end
    render turbo_stream: turbo_stream.update("resp-table-body", partial: "tasks/task", collection: @@executed_all, as: :task )
  end

  def create
    @task = current_user.tasks.build(task_params.merge(status: :registred, priority: @priority))   # Not the final implementation!
      # authorize @division   
    respond_to do |format|
      if @task.save
        format.html { redirect_to tasks_path, notice: t('notice.record_create') }
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    # authorize @division    
    respond_to do |format|
      if @task.update(task_params.merge(priority: @priority))
        format.html { redirect_to tasks_path, notice: t('notice.record_edit') }
        format.turbo_stream
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    # authorize @division
    if @task.destroy
      respond_to do |format|
        format.html { redirect_to tasks_path, notice: t('notice.record_destroy') }
        format.turbo_stream
      end
    else
      flash.now[:error] = t('notice.record_destroy_errors')
    end
  end

  def report_tasks_xls
    respond_to do |format|
      format.zip { respond_with_zipped_tasks($report_tasks, $date_start, $date_end) }
    end
  end

  private

  def respond_with_zipped_tasks(tasks, date_start, date_end)  
    # users = User.where(id: ( @report_tasks.pluck(:user_id).uniq))
    compressed_filestream = Zip::OutputStream.write_buffer do |zos|
      # users.each do |user|
      zos.put_next_entry "task_report_#{DateTime.now}.xlsx"
      zos.print render_to_string(
        layout: false, handlers: [:axlsx], formats: [:xlsx],
        template: 'tasks/tasks_report',
        locals: { tasks:  tasks.reorder(:created_at), date_start: date_start, date_end: date_end }
      )
      # end
    end
    compressed_filestream.rewind
    send_data compressed_filestream.read, filename: 'report_tasks.zip'    
  end

  def partial_device
    if mobile_device?
      'tasks/mobile/task'
    else
      'tasks/task'
    end
  end

  def set_priority
    @priority = Category.find(task_params[:category_id]).priority
  end


  def set_task
    @task = Task.find(params[:id])
  end

  def update_status(*args) 
    @task.update!(*args)
    render turbo_stream: turbo_stream.replace(@task, partial: partial_device, locals: { task: @task } )
  end

  def task_params
    params.require(:task).permit(:division_id, :executor_id, :category_id, :description)
  end

end