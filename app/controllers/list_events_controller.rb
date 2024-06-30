class ListEventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_list_event, except: [ :index, :destroy_photos ]

  def edit

  end
 
  def update
    # authorize @division    
    respond_to do |format|
      if @list_event.update(list_event_params)
        format.html { redirect_to list_event_path, success: t('notice.record_edit') }
        format.turbo_stream { flash.now[:warning] = t('notice.record_edit') }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def update_status
    if @list_event.check_status == 2 || @list_event.check_status == 0
      @list_event.update!(check_status: 1)
    else
      @list_event.update!(check_status: 0)
    end
    respond_to do |format|
      format.html { redirect_to list_event_path, success: t('notice.record_edit') }
      format.turbo_stream { flash.now[:warning] = t('notice.record_edit') }
    end
  end


  def new_photos;  end

  def create_photos
    @list_event.photos.attach(params[:list_event][:photos])
  end

  def destroy_photos
    @list_event = ListEvent.find(params[:list_event_id])
    @photo = ActiveStorage::Attachment.find(params[:id])
    @photo.purge
  end
  

  private

  def set_list_event
    @list_event = ListEvent.find(params[:id])
  end

  def list_event_params
    params.require(:list_event).permit(:comment)
  end

end