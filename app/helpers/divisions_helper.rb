module DivisionsHelper

  def closed_at(division)
    content_tag(:span, content_tag(:i, "", class: "bi bi-lock-fill text-danger")) if !division.active
  end
end
