class MissionExecutorsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_mission_executor, except: [ :new, :create]
  before_action :set_mission, except: [ :new, :create]

  def new
    # authorize User
    @mission= Mission.find(params[:mission_id])
    @mission_executor = @mission.mission_executors.build
    @executor_lists = executor_list(@mission)
  end

  def show
    # authorize completed_task
  end

  def edit
    # authorize completed_task
    @executor_lists = executor_list(@mission)
  end

  def create
    @mission = Mission.find(mission_executor_params[:mission_id])
    if current_user.subordinates_of?(User.find(mission_executor_params[:executor_id]))
      save_params = mission_executor_params.merge!(parent_executor_id: current_user.id, coordinator_id:  current_user.id)
    else
      save_params = mission_executor_params.merge!(coordinator_id: current_user.id)
    end
    @mission_executor = @mission.mission_executors.build(save_params) 
   # Not the final implementation!
      # authorize completed_task   
    respond_to do |format|
      if @mission_executor.save
        # format.html { redirect_to task_path(@task), notice: t('notice.record_create') }
        @parent_executors = MissionExecutor.parent_for_executor(@mission)
        @replies_executors = MissionExecutor.replies_for_executor(@mission)
        format.turbo_stream { flash.now[:success] = t('notice.record_create') }
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
        format.turbo_stream { flash.now[:warning] = t('notice.record_edit') }
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
        format.turbo_stream { flash.now[:danger] = t('notice.record_destroy') }
      end
    else
      flash.now[:error] = t('notice.record_destroy_errors')
    end
  end

  def agree 
    update_status(status: :agree, close_at: DateTime.now)       
  end

  def canceled
    update_status(status: :canceled, close_at: DateTime.now)
  end

  def rework
    @mission_executor.update!(status: :in_rework)
    mission_approvals = @mission_executor.mission.mission_approvals
    mission_approvals.where(mission_executor_id: @mission_executor.id).delete_all
    redirect_to edit_completed_mission_path(@mission_executor.completed_missions.last) 
  end

  def executed
    if @mission.mission_executors.present?
      @mission.mission_executors.each do |mission_executor|
        unless mission_executor.close_at.present?
          mission_executor.update!(status: :executed, close_at: DateTime.now)
        end
      end
    end
    update_status(status: :executed, close_at: DateTime.now)
  end

  private

  def executor_list(mission)
    if current_user.moderator?
      User.includes(:profile).moderator_executor_users(current_user)
      .except_control_on_author(mission.author, mission.control_executor)
      .except_mission_executors(mission.mission_executors.pluck(:executor_id))
    else
      User.includes(:profile).executor_users(current_user)
      .except_control_on_author(mission.author, mission.control_executor)
      .except_mission_executors(mission.mission_executors.pluck(:executor_id))
    end

  end 

  def update_status(*args) 
    @mission_executor.update!(*args)
    mission_approvals = @mission_executor.mission.mission_approvals
    mission_approvals.where(mission_executor_id: @mission_executor.id).delete_all
    render turbo_stream: turbo_stream.replace("mission_executor_#{@mission_executor.id}", @mission_executor)
  end

  def set_mission
    @mission = @mission_executor.mission
  end

  def set_mission_executor 
    @mission_executor  = MissionExecutor.find(params[:id])
  end

  def mission_executor_params
    params.require(:mission_executor).permit(:mission_id, :executor_id, :description, :limit_at)
  end

  def partial_device
    if mobile_device?
      'missions/mobile/mission'
    else
      'missions/mission'
    end
  end
end
