class Admin::SubCategoriesController < Admin::CatalogController
 
  private

  def permit_params
    params.require(controller_name.classify.underscore.to_sym).permit(:name, :category_id, :workload)
  end

end