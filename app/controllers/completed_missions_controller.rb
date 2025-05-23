class CompletedMissionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_completed_mission, except: [ :new, :create]
  before_action :set_mission, except: [ :new, :create]


  def new
    # authorize User
    @mission_executor = MissionExecutor.find(params[:mission_executor_id])
    @completed_mission = @mission_executor.completed_missions.build
  end

  def show
    # authorize completed_task
    
  end

  def edit
    # authorize completed_task
    @mission_executor = @completed_mission.mission_executor
  end

  def create
    @mission_executor = MissionExecutor.find(params[:completed_mission][:mission_executor_id])
    @completed_mission = @mission_executor.completed_missions.build(completed_mission_params)    # Not the final implementation!
      # authorize completed_task   
    @completed_mission.app_files.attach(params[:completed_mission][:app_files])
    respond_to do |format|
      if @completed_mission.save
        @completed_mission.mission_executor.update!(status: :in_approval)
        @mission_executor.mission.mission_approvals.build(mission_executor_id: @mission_executor.id, coordinator_id:  @mission_executor.coordinator_id).save
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
      if @completed_mission.update(completed_mission_params)
        format.html { redirect_to missiom_path(@mission), notice: t('notice.record_edit') }
        format.turbo_stream { flash.now[:warning] = t('notice.record_edit') }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy   
    # authorize completed_task
    if @completed_mission.destroy
      respond_to do |format|
        format.html { redirect_to mission_path(@mission), notice: t('notice.record_destroy') }
        format.turbo_stream { flash.now[:danger] = t('notice.record_destroy') }
      end
    else
      flash.now[:error] = t('notice.record_destroy_errors')
    end
  end

  def new_app_file;  end

  def create_app_file
    @completed_mission.app_files.attach(params[:completed_missions][:app_files])
  end

  def destroy_app_files
    @app_files = ActiveStorage::Attachment.find(params[:app_file_id])
    @app_files.purge
  end

  private

  def set_mission
    @mission = @completed_mission.mission_executor.mission
  end

  def set_completed_mission
    @completed_mission = CompletedMission.find(params[:id])
  end

  def completed_mission_params
    params.require(:completed_mission).permit(:mission_executor_id, :description, :comment, :app_files)
  end
end