class PerformedWorksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_performed_work, except: [ :new, :create]
  before_action :set_task, except: [ :new, :create]


  def new
    # authorize User
    @task = Task.find(params[:task_id])
    @performed_work = @task.performed_works.build
  end

  def show
    # authorize completed_task
    
  end

  def edit
    # authorize completed_task
    
  end

  def create
    @task = Task.find(performed_work_params[:task_id])
    @performed_work = @task.performed_works.build(performed_work_params)    # Not the final implementation!
      # authorize completed_task   
    respond_to do |format|
      if @performed_work.save
        # format.html { redirect_to task_path(@task), notice: t('notice.record_create') }
        format.turbo_stream { flash.now[:success] = t('notice.record_create') }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    # authorize completed_task 
    respond_to do |format|
      if @performed_work.update(performed_work_params)
        format.html { redirect_to task_path(@task), notice: t('notice.record_edit') }
        format.turbo_stream { flash.now[:warning] = t('notice.record_edit') }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy   
    # authorize completed_task
    if @performed_work.destroy
      respond_to do |format|
        format.html { redirect_to task_path(@task), notice: t('notice.record_destroy') }
        format.turbo_stream { flash.now[:danger] = t('notice.record_destroy') }
      end
    else
      flash.now[:error] = t('notice.record_destroy_errors')
    end
  end

  private

  def set_task
    @task = @performed_work.task
  end

  def set_performed_work
    @performed_work = PerformedWork.find(params[:id])
  end

  def performed_work_params
    params.require(:performed_work).permit(:task_id, :sub_category_id, :time_start, :time_end, :comment, :workload)
  end
end
