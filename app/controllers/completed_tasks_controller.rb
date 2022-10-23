class CompletedTasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_completed_task, except: [ :index, :new, :create]
  
  def index
    # authorize User
    if current_user.user?      
      @q = CompletedTask.includes(:user, :profile, :categories, :sub_categories, :division).where(user_id: current_user).ransack(params[:q])
    else
      @q = CompletedTask.ransack(params[:q])
    end
    @q.sorts = ['created_at desc', 'profile_fullname asc'] if @q.sorts.empty?
    @completed_tasks = @q.result(disinct: true)  
    @users = User.all
    @divisions = Division.all
    @categories = SubCategory.all
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
