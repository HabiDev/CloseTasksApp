class Admin::MissionTypesController < Admin::CatalogController
  private

  def permit_params
    params.require(controller_name.classify.underscore.to_sym).permit(:name, :view_classing)
  end
end