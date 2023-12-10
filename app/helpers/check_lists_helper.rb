module CheckListsHelper

  def check_list_status(resource)
    if resource.list_events.processed  < resource.list_events.count
      content_tag(:span, "Не пройден(#{resource.list_events.count - resource.list_events.processed})",
                   class: "d-block small text-truncate text-danger")
    elsif resource.list_events.not_processed > 0 
      content_tag(:span, "C замечаниями(#{resource.list_events.not_processed})", 
                  class: "d-block small text-truncate text-warning")
    else
      content_tag(:span, "Без замечаний", class: "d-block small text-truncate text-success")
    end
  end
end