class MissionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_mission, except: [ :index, :new, :create, :mission_calendar]
  # before_action :set_priority, only: [ :create, :update]
  
  def index
    # authorize User
    if current_user.user? || current_user.guide?    
      @q = Mission.includes(:author, :mission_type, :mission_executors, :mission_approvals).joins(:mission_executors)
                        .where(author_id: current_user)
                        .or(Mission.where(control_executor_id: current_user))
                        .or(Mission.where("mission_executors.executor_id = ?", current_user))
                        .ransack(params[:q])
    else
      @q = Mission.includes(:author, :control_executor, :mission_type).ransack(params[:q])
    end
    @q.sorts = ['created_at desc', 'mission_type_id asc'] if @q.sorts.empty?
    @pagy, @missions = pagy(@q.result(disinct: true).includes(:author, :mission_type, :mission_executors, :mission_approvals), items: mobile_device? ? 3 : 10)
    # @missions = @missions.distinct
    @users = User.all
    @mission_types = MissionType.all
    @count_missions = @q.result.count
  end

  def new
    # authorize User
    @mission = Mission.new
    if current_user.moderator? 
      @user_list = User.moderator_control_user(current_user)
    else
      @user_list = User.control_user(current_user)
    end
    # @control_users = current_user.subordinates.merge!(current_user)
  end

  def show
    # authorize @division
    @mission.looked! unless current_user.author_of?(@mission) || current_user.control_executor_of?(@mission)
    @mission_executors = @mission.mission_executors
    @parent_executors = MissionExecutor.parent_for_executor(@mission)
    @replies_executors = MissionExecutor.replies_for_executor(@mission)
    @mission_executor = @mission_executors.where(executor: current_user)
    @mission_executor.each { |mission| mission.mission_looked! }
    # if @mission_executors.where(executor: current_user).present?
    #   @mission_executors.where(executor: current_user).mission_looked!
    # end
    # @completed_missions = @mission.completed_missions
  end

  def edit
    # authorize @division  
    # @control_users = (current_user.subordinates << current_user) 
  end

  def approval 
    update_status(status: :in_approval)       
  end

  def canceled
    if @mission.mission_executors.present?
      @mission.mission_executors.each do |mission_executor|
        unless mission_executor.close_at.present?
          mission_executor.update!(status: :canceled, close_at: DateTime.now)
        end
      end
    end
    update_status(status: :canceled, close_at: DateTime.now)
  end

  def rework
   update_status(status: :in_rework)
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
 
  def delayed
    if @mission.mission_executors.present?
      @mission.mission_executors.each do |mission_executor|
        unless mission_executor.close_at.present?
          mission_executor.update!(limit_at: 1.month.since)
        end
      end
    end
    update_status(status: :delayed, execution_limit_at: 1.month.since)   
  end  

  def create
    if current_user&.moderator?
      @mission = Mission.create(mission_params.merge(status: :registred))   # Not the final implementation!
    else
      @mission = current_user.missions.build(mission_params.merge(status: :registred))   # Not the final implementation!
    end
    # @mission = current_user.missions.build(mission_params.merge(status: :registred))   # Not the final implementation!
      # authorize @division   
    respond_to do |format|
      if @mission.save
        @mission.mission_executors.build(executor_id: mission_params[:responsible_executor_id], 
                                         limit_at: @mission.execution_limit_at,
                                         description: @mission.description,
                                         responsible: true,
                                         coordinator_id: mission_params[:control_executor_id],
                                         status: :registred).save
        format.html { redirect_to missions_path, notice: t('notice.record_create') }
        format.turbo_stream { flash.now[:success] = t('notice.record_create') }
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
        format.turbo_stream { flash.now[:warning] = t('notice.record_edit') }
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
        format.turbo_stream { flash.now[:danger] = t('notice.record_destroy') }
      end
    else
      flash.now[:error] = t('notice.record_destroy_errors')
    end
  end

  def mission_calendar
    @mission_executors = current_user.mission_executors.opened
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
    params.require(:mission).permit(:mission_type_id, :control_executor_id, :execution_limit_at, 
                                    :description, :division_id, :author_id, :responsible_executor_id)
  end

end