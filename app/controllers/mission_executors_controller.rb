class MissionExecutorsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_mission_executor, except: [ :new, :create]
  before_action :set_mission, except: [ :new, :create]


  def new
    # authorize User
    @mission= Mission.find(params[:mission_id])
    @mission_executor = @mission.mission_executors.build
  end

  def show
    # authorize completed_task
    
  end

  def edit
    # authorize completed_task
    
  end

  def create
    @mission = Mission.find(mission_executor_params[:mission_id])
    @mission_executor = @mission.mission_executors.build(mission_executor_params)    # Not the final implementation!
      # authorize completed_task   
    respond_to do |format|
      if @mission_executor.save
        # format.html { redirect_to task_path(@task), notice: t('notice.record_create') }
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    # authorize completed_task 
    respond_to do |format|
      if @mission_executor.update(mission_executor_params)
        format.html { redirect_to mission_executor_path(@mission), notice: t('notice.record_edit') }
        format.turbo_stream
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy   
    # authorize completed_task
    if @mission_executor.destroy
      respond_to do |format|
        format.html { redirect_to mission_path(@mission), notice: t('notice.record_destroy') }
        format.turbo_stream
      end
    else
      flash.now[:error] = t('notice.record_destroy_errors')
    end
  end

  private

  def set_mission
    @mission = @mission_executor.mission
  end

  def set_mission_executor 
    @mission_executor  = MissionExecutor.find(params[:id])
  end

  def mission_executor_params
    params.require(:mission_executor).permit(:mission_id, :executor_id, :description, :limit_at)
  end
end
