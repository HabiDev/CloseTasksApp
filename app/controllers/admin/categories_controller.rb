class Admin::CategoriesController < Admin::CatalogController

  private

  def permit_params
    params.require(controller_name.classify.underscore.to_sym).permit(:name, :priority_id)
  end

end