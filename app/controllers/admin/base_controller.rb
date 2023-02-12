class Admin::BaseController < ApplicationController

  layout -> { turbo_frame_request? ? false : "admin" }

  before_action :authenticate_user!
  before_action :admin_required!
  before_action :get_instance, only: [:show, :edit, :update, :destroy]

  def index
    @pagy, @resources = pagy(model_class.all items: mobile_device? ? 3 : 10) 
    @model = model_class
  end

  def new
    @resource = model_class.new
  end

  def create
    @resource = model_class.create(permit_params)
    @model = model_class
    respond_to do |format|
      if @resource.save
        format.html { redirect_to @resource, notice: t('notice.record_create') }
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @resource.update(division_params)
        format.html { redirect_to @resource, notice: t('notice.record_edit') }
        format.turbo_stream
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end 

  def destroy
    if @resource.destroy
      respond_to do |format|
        format.html { redirect_to divisions_path, notice: t('notice.record_destroy') }
        format.turbo_stream
      end
    else
      flash.now[:error] = t('notice.record_destroy_errors')
    end
  end

  private

  def admin_required!
    redirect_to root_path, alert: t('errors.access_denied') unless current_user.admin?
  end

  def model_class
    controller_name.classify.constantize
  end

  def get_instance
    @resource = model_class.find(params[:id])
  end

  def permit_params
    params.require(controller_name.classify.underscore.to_sym).permit!
  end


end