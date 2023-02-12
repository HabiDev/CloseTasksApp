class Admin::CatalogController < Admin::BaseController

  # layout 'admin'
  before_action :get_instance, only: [:show, :edit, :update, :destroy]

  def index
    @pagy, @resources = pagy(model_class.all, items: mobile_device? ? 3 : 10) 
    @model = model_class
    @resource_name = self.controller_name.singularize
    render template: "admin/catalog/index"
  end

  def new
    @resource = model_class.new
    render template: "admin/catalog/new_edit", locals: { title: t('resource.create')}
  end

  def edit
    render template: "admin/catalog/new_edit", locals: { title: t('resource.edit') }
  end

  def create
    @resource = model_class.create(permit_params)
    @model = model_class
    respond_to do |format|
      if @resource.save
        format.html { redirect_to action: :index, notice: t('notice.record_create') }
        format.turbo_stream { render template: "admin/catalog/create" }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @resource.update(permit_params)
        format.html { redirect_to action: :index, notice: t('notice.record_edit') }
        format.turbo_stream { render template: "admin/catalog/update" }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end 

  def destroy
    if @resource.destroy
      respond_to do |format|
        format.html { redirect_to action: :index, notice: t('notice.record_destroy') }
        format.turbo_stream { render template: "admin/catalog/destroy" }
      end
    else
      flash.now[:error] = t('notice.record_destroy_errors')
    end
  end

  private

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