class MissionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_mission, except: [ :index, :new, :create, :mission_calendar, :search]
  # before_action :set_priority, only: [ :create, :update]
  
  def index
    # authorize User
    if params[:q] && params[:q][:find_all]
      if current_user.user? || current_user.guide?    
        @q = Mission.includes(:author, :mission_type, :mission_executors, :mission_approvals).joins(:mission_executors)
                          .where(author_id: current_user)
                          .or(Mission.where(control_executor_id: current_user))
                          .or(Mission.where("mission_executors.executor_id = ?", current_user)).ransack(params[:q])                         
      else
        @q = Mission.includes(:author, :control_executor, :mission_type).ransack(params[:q])
      end
    else
      if current_user.user? || current_user.guide?    
        @q = Mission.includes(:author, :mission_type, :mission_executors, :mission_approvals).joins(:mission_executors)
                          .where(author_id: current_user)
                          .or(Mission.where(control_executor_id: current_user))
                          .or(Mission.where("mission_executors.executor_id = ?", current_user))
                          .and(Mission.where(close_at: nil)).ransack(params[:q])
                          
      else
        @q = Mission.includes(:author, :control_executor, :mission_type).where(close_at: nil).ransack(params[:q])
      end      
    end


    if (params[:overdue].present?) 
      if (current_user.user? || current_user.guide? )
        @q = Mission.includes(:author, :mission_type, :mission_executors, :mission_approvals).joins(:mission_executors)
                                .where(author_id: current_user)
                                .or(Mission.where(control_executor_id: current_user))
                                .or(Mission.where("mission_executors.executor_id = ?", current_user)).overdue.ransack(params[:q])
      else
        @q = Mission.includes(:author, :control_executor, :mission_type).overdue.ransack(params[:q])
      end
    end
    
    @q.sorts = ['created_at DESC', 'limit_at ASC', 'mission_type_id ASC'] if @q.sorts.empty?
    @pagy, @missions = pagy(@q.result(disinct: true).includes(:author, :mission_type, :mission_executors, :mission_approvals), items: mobile_device? ? 3 : 10)
    # @missions = @missions.distinct
    @users = User.all.includes(:profile)
    @mission_types = MissionType.all
    @count_missions = @q.result.count
  end

  def new
    # authorize User
    @mission = Mission.new(control_executor: current_user)
    @user_list = set_user_list

    # @control_users = current_user.subordinates.merge!(current_user)
  end

  def show
    # authorize @division
    @mission.looked! unless current_user.author_of?(@mission) || current_user.control_executor_of?(@mission)
    @mission_executors = @mission.mission_executors
    @parent_executors = MissionExecutor.includes(:executor).parent_for_executor(@mission)
    @replies_executors = MissionExecutor.includes(:executor).replies_for_executor(@mission)
    @mission_executor = @mission_executors.where(executor: current_user)
    @mission_executor.each { |mission| mission.mission_looked! }

  end

  def edit
    # authorize @division  
    @user_list = set_user_list

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
    # @er = between_day(params[:delayed_date]) 
    # dsd
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
        @user_list = set_user_list
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
        @user_list = set_user_list
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
    @mission_executors = current_user.mission_executors.opened(current_user)
    @mission_control_executors = Mission.opened(current_user)
    @events = []
    @mission_control_executors.each do |control_executor|
      @events << Event.new(mission_id: control_executor.id, number: control_executor.number, limit_at: control_executor.limit_at)
    end

    @mission_executors.each do |mission_executor|
      @events << Event.new(mission_id: mission_executor.mission_id, number: mission_executor.mission.number, limit_at: mission_executor.limit_at)
    end
  end

  private

  def between_day(date)
    if date.present?
      (date.to_datetime - @mission.limit_at.to_datetime).to_i
    else
      return 0
    end
  end

  def partial_device
    if mobile_device?
      'missions/mobile/mission'
    else
      'missions/mission'
    end
  end

  def set_user_list
    # if current_user.moderator? 
    #   User.includes(:profile).moderator_control_user(current_user)
    # else
    #   User.includes(:profile).control_user(current_user)
    # end
    User.includes(:profile).control_user(current_user)
  end

  def set_mission
    @mission = Mission.find(params[:id])
  end

  def update_status(*args) 
    @mission.update!(*args)
    @mission.mission_approvals.delete_all
    redirect_to missions_path
    # render turbo_stream: turbo_stream.replace(@mission, partial: partial_device, locals: { mission: @mission} )
  end

  def mission_params
    params.require(:mission).permit(:mission_type_id, :control_executor_id, :execution_limit_at, 
                                    :description, :division_id, :author_id, :responsible_executor_id)
  end

end