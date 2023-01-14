class Admin::SubDepartmentsController < Admin::CatalogController

  private

  def permit_params
    params.require(controller_name.classify.underscore.to_sym).permit(:name, :department_id)
  end

end