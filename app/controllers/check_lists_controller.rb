class CheckListsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_check_list, except: [ :index, :new, :create, :report_check_list_xls]
  
  def index
    # authorize User
    if current_user.user?      
      @q = CheckList.includes(:author, :check_list_type, :division, :list_events)
                        .where(author_id: current_user)
                        .ransack(params[:q])
    else
      @q = CheckList.includes(:author, :check_list_type, :division, :list_events).ransack(params[:q])
    end
    @q.sorts = ['created_at desc'] if @q.sorts.empty?
    @pagy, @check_lists = pagy(@q.result(disinct: true).includes(:author, :check_list_type, :division), items: mobile_device? ? 3 : 10) 
    $report_check_list = @q.result(disinct: true).includes(:author, :check_list_type, :division)
    @users = User.all
    # @mission_types = MissionType.all
    # @count_missions = @q.result.count
  end

  def new
    # authorize User
    @check_list = CheckList.new 
  end

  def show; end

  def edit; end

  def create
    @check_list = current_user.check_lists.build(check_list_params)
      # authorize @division   
    respond_to do |format|
      if @check_list.save
        @sub_check_lists = SubCheckList.type_lists(@check_list.check_list_type)
        if @sub_check_lists.present?
          @sub_check_lists.each do |list|
            ListEvent.create!(check_list_id: @check_list.id, sub_check_list_id: list.id)
          end
        end
        format.html { redirect_to check_list_path(@check_list), notice: t('notice.record_create') }
        format.turbo_stream { flash.now[:success] = t('notice.record_create') }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    # authorize @division    
    respond_to do |format|
      if @check_list.update(check_list_params)
        format.html { redirect_to check_lists_path, notice: t('notice.record_edit') }
        format.turbo_stream { flash.now[:warning] = t('notice.record_edit') }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    # authorize @division
    if @check_list.destroy
      respond_to do |format|
        format.html { redirect_to check_lists_path, notice: t('notice.record_destroy') }
        format.turbo_stream { flash.now[:danger] = t('notice.record_destroy') }
      end
    else
      flash.now[:error] = t('notice.record_destroy_errors')
    end
  end

  def report_check_list_xls
    respond_to do |format|
      format.zip { respond_with_zipped_tasks($report_check_list) }
    end
  end

  private

  def respond_with_zipped_tasks(check_lists)  
    # users = User.where(id: ( @report_tasks.pluck(:user_id).uniq))
    compressed_filestream = Zip::OutputStream.write_buffer do |zos|
      check_lists.each do |check_list|
        zos.put_next_entry "TO_#{check_list.division_id}.xlsx"
        zos.print render_to_string(
          layout: false, handlers: [:axlsx], formats: [:xlsx],
          template: 'check_lists/check_list_report',
          locals: { check_list:  check_list }
        )
      end
    end
    compressed_filestream.rewind
    send_data compressed_filestream.read, filename: 'check_list_report.zip'    
  end

  def partial_device
    if mobile_device?
      'check_lists/mobile/check_list'
    else
      'check_lists/check_list'
    end
  end

  def set_check_list
    @check_list = CheckList.find(params[:id])
  end

  # def update_status(*args) 
  #   @check_list.update!(*args)
  #   render turbo_stream: turbo_stream.replace(@check_list, partial: partial_device, locals: { check_list: @check_list} )
  # end

  def check_list_params
    params.require(:check_list).permit(:division_id, :author_id, :check_list_type_id, :status)
  end

end