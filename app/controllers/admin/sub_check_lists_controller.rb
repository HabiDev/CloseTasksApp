class Admin::SubCheckListsController < Admin::CatalogController
 
  private

  def permit_params
    params.require(controller_name.classify.underscore.to_sym).permit(:name, :check_list_type_id, :check_list_group_id)
  end

end