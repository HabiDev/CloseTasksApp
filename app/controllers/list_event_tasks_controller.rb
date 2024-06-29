class ListEventTasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_list_event, only: [:new, :create]
  before_action :set_priority, only: [ :create, :update]
  
  def new
    # authorize User
    @task = @list_event.tasks.build(division_id: @list_event.check_list.division_id, 
                                    author_id: @list_event.check_list.author_id )  
  end

  def create
    @task = @list_event.tasks.build(list_event_task_params.merge(status: :registred, 
                                                                 priority: @priority, 
                                                                 author_id: @list_event.check_list.author_id, 
                                                                 division_id: @list_event.check_list.division_id)) 
    respond_to do |format|
      if @task.save
        format.html { redirect_to tasks_path, notice: t('notice.record_create') }
        format.turbo_stream { flash.now[:success] = t('notice.record_create') }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private

  def partial_device
    if mobile_device?
      'tasks/mobile/task'
    else
      'tasks/task'
    end
  end

  def set_priority
    @priority = Category.find(list_event_task_params[:category_id]).priority
  end

  def set_list_event
    @list_event = ListEvent.find(params[:list_event_id])
  end

  def list_event_task_params
    params.require(:task).permit(:division_id, :executor_id, :category_id, :description)
  end

end