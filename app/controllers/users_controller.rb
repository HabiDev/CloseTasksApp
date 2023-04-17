class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, except: [ :index, :new, :create]
  
  def index
    # authorize User
    # @q = User.includes(:profile).where(admin: false).search(params[:q])
    # @q.sorts = ['profile_surname asc', 'created_at desc'] if @q.sorts.empty?
    # @users = @q.result(disinct: true)
    @pagy, @users = pagy(User.all, items: mobile_device? ? 3 : 10) 
  end

  def new
    # authorize Users
    #@user = User.new(password: 'UserBlock', password_confirmation: 'UserBlock', locked_at: DateTime.now)
    @user = User.new
    @user.build_profile
  end

  def show
    # authorize @user
  end

  def edit
    # authorize @user
    @user.profile
  end

  def create
    @user = User.new(user_params)    # Not the final implementation!
      # authorize @user   
    respond_to do |format|
      if @user.save
        format.html { redirect_to users_path, notice: t('notice.record_create') }
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    # authorize @user
    
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_path, notice: t('notice.record_edit') }
        format.turbo_stream
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    # authorize @user
    if @user.destroy
      respond_to do |format|
        format.html { redirect_to users_path, notice: t('notice.record_destroy') }
        format.turbo_stream
      end
      # flash[:success] = "Пользователь удачно удален."
      # redirect_to users_path, status: :see_other
    else
      flash[:error] = t('notice.record_destroy_errors')
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :type_role, :password, :password_confirmation, :manager_id,
                                 profile_attributes: [:full_name, :sub_department_id, :position_id, :mobile])
  end

end
