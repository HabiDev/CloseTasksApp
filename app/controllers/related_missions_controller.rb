class RelatedMissionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_mission, only: [ :new ]
  before_action :set_old_mission, only: [ :create]
  before_action :set_related_mission, only: [ :destroy]
  

  def new
    # authorize User
    @related_mission = @mission.related_missions.build
    @mission_lists = Mission.except_related_mission(@mission.related_missions.pluck(:related))
  end

  def create
    if @old_mission.present?
      save_params = related_mission_params.merge!(number_mission: @old_mission.number)
    else
      save_params = related_mission_params
    end
    @related_mission = RelatedMission.create(save_params)
    respond_to do |format|
      if @related_mission.save
        # format.html { redirect_to task_path(@task), notice: t('notice.record_create') }
        format.turbo_stream { flash.now[:success] = t('notice.record_create') }
      else
        format.html { render :new, status: :unprocessable_entity }
        @mission_lists = Mission.except_related_mission(@mission.related_missions.pluck(:related))
      end
    end
  end

  def destroy   
    # authorize completed_task
    @mission = @related_mission.mission
    if @related_mission.destroy
      respond_to do |format|
        format.html { redirect_to mission_path(@mission), notice: t('notice.record_destroy') }
        format.turbo_stream { flash.now[:danger] = t('notice.record_destroy') }
      end
    else
      flash.now[:error] = t('notice.record_destroy_errors')
    end
  end

  private

  def set_old_mission
    @old_mission =  Mission.find(related_mission_params[:related])
    @mission =  Mission.find(related_mission_params[:mission_id])
  end

  def set_mission
    @mission =  Mission.find(params[:mission_id])
  end

  def set_related_mission
    @related_mission =  RelatedMission.find(params[:id])
  end

  def related_mission_params
    params.require(:related_mission).permit(:mission_id, :related)
  end

  def partial_device
    if mobile_device?
      'missions/mobile/mission'
    else
      'missions/mission'
    end
  end
end
