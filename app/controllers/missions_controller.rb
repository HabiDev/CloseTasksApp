class MissionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_mission, except: [ :index, :new, :create]
  # before_action :set_priority, only: [ :create, :update]
  
  def index
    # authorize User
    if current_user.user?      
      @q = Mission.includes(:author, :mission_type)
                        .where(author_id: current_user)
                        .or(Mission.where(control_executor_id: current_user))
                        .ransack(params[:q])
    else
      @q = Mission.includes(:author, :control_executor, :mission_type).ransack(params[:q])
    end
    @q.sorts = ['created_at desc', 'mission_type_id asc'] if @q.sorts.empty?
    @pagy, @missions = pagy(@q.result(disinct: true).includes(:author, :mission_type), items: mobile_device? ? 3 : 10) 
    @users = User.all
    @mission_types = MissionType.all
  end

  def new
    # authorize User
    @mission = Mission.new   
  end

  def show
    # authorize @division
    @mission.looked! unless current_user.author_of?(@mission) || !current_user.control_executor_of?(@mission)
    @mission_executors = @mission.mission_executors
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

  def create
    @mission = current_user.missions.build(mission_params.merge(status: :registred))   # Not the final implementation!
      # authorize @division   
    respond_to do |format|
      if @mission.save
        format.html { redirect_to missions_path, notice: t('notice.record_create') }
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    # authorize @division    
    respond_to do |format|
      if @mission.update(mission_params)
        format.html { redirect_to missions_path, notice: t('notice.record_edit') }
        format.turbo_stream
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    # authorize @division
    if @mission.destroy
      respond_to do |format|
        format.html { redirect_to missions_path, notice: t('notice.record_destroy') }
        format.turbo_stream
      end
    else
      flash.now[:error] = t('notice.record_destroy_errors')
    end
  end

  private

  def partial_device
    if mobile_device?
      'missions/mobile/mission'
    else
      'missions/mission'
    end
  end

  # def set_priority
  #   @priority = Category.find(task_params[:category_id]).priority
  # end


  def set_mission
    @mission = Mission.find(params[:id])
  end

  def update_status(*args) 
    @mission.update!(*args)
    render turbo_stream: turbo_stream.replace(@mission, partial: partial_device, locals: { mission: @mission} )
  end

  def mission_params
    params.require(:mission).permit(:mission_type_id, :control_executor_id, :execution_limit_at, :description)
  end

end