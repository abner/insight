module SortingHelper

  def sort_options_hash(feedback_form)
    sort_hash = {}

    feedback_form.feedback_attributes.each do |attribute|
      sort_hash["#{attribute.name}_asc"] = "#{attribute.display_label} #{I18n.t('ascending')}"
      sort_hash["#{attribute.name}_desc"] = "#{attribute.display_label} #{I18n.t('descending')}"
    end
    sort_hash
  end

end
