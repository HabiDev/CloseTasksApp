class CompletedTasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_completed_task, except: [ :index, :new, :create]
  
  def index
    # authorize User
    # @q = User.includes(:profile).where(admin: false).search(params[:q])
    # @q.sorts = ['profile_surname asc', 'created_at desc'] if @q.sorts.empty?
    # completed_tasks = @q.result(disinct: true)
    if current_user.user?
      @completed_tasks =current_user.completed_tasks.ordered.created_date(1.day.ago)
    else
      @completed_tasks = CompletedTask.ordered
    end
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
        format.turbo_stream
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
        format.turbo_stream
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
        format.turbo_stream
      end
    else
      flash.now[:error] = t('notice.record_destroy_errors')
    end
  end

  private

  def set_completed_task

    @completed_task = CompletedTask.find(params[:id])
  end

  def completed_task_params
    params.require(:completed_task).permit(:division_id, :sub_category_id, :comment)
  end
end
