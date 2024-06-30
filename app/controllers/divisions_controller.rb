class DivisionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_division, except: [ :index, :new, :create]
  
  def index
    # authorize User
    # @q = User.includes(:profile).where(admin: false).search(params[:q])
    # @q.sorts = ['profile_surname asc', 'created_at desc'] if @q.sorts.empty?
    # @divisions = @q.result(disinct: true)
    @pagy, @divisions = pagy(Division.ordered, items: mobile_device? ? 3 : 12 )
  end

  def new
    # authorize User
    #@division = User.new(password: 'UserBlock', password_confirmation: 'UserBlock', locked_at: DateTime.now)
    @division = Division.new    
  end

  def show
    # authorize @division
  end

  def edit
    # authorize @division
  end

  def create
    @division = Division.new(division_params)    # Not the final implementation!
      # authorize @division   
    respond_to do |format|
      if @division.save
        format.html { redirect_to divisions_path, notice: t('notice.record_create') }
        format.turbo_stream { flash.now[:success] = t('notice.record_create') }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    # authorize @division    
    respond_to do |format|
      if @division.update(division_params)
        format.html { redirect_to divisions_path, notice: t('notice.record_edit') }
        format.turbo_stream { flash.now[:warning] = t('notice.record_edit') }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    # authorize @division
    if @division.destroy
      respond_to do |format|
        format.html { redirect_to divisions_path, notice: t('notice.record_destroy') }
        format.turbo_stream { flash.now[:danger] = t('notice.record_destroy') }
      end
    else
      flash.now[:error] = t('notice.record_destroy_errors')
    end
  end

  private

  def set_division
    @division = Division.find(params[:id])
  end

  def division_params
    params.require(:division).permit(:name, :department_id, :address, :email, :active)
  end

end