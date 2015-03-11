module FeedbackFormsHelper
  def actions_for feedback_form
    capture do
      if current_user_can?(:write_feedback_form, feedback_form)
      concat (link_to(
                edit_feedback_target_feedback_form_path(feedback_form.feedback_target, feedback_form)
                ) do
                    content_tag(:span, pad(t('Edit')), class: 'fa fa-edit')
                  end).html_safe
      end
      if current_user_can?(:destroy_feedback_form, feedback_form)
        concat "&nbsp;".html_safe
        concat render :partial => 'feedback_forms/actions/destroy', :locals => {feedback_form: feedback_form}
      end
      concat "&nbsp;".html_safe
      concat (link_to(feedback_target_feedback_form_feedbacks_path(feedback_form.feedback_target, feedback_form)) do
                  content_tag(:span, pad(translate('Feedbacks')) + " ", :class => 'fa fa-comment-o')
                end).html_safe
    end #raw actions.join
  end

  def url_for_form(feedback_target, feedback_form)
    if feedback_form.new_record?
      feedback_target_feedback_forms_path(feedback_target)
    else
      feedback_target_feedback_form_path(feedback_target, feedback_form)
    end
  end

  def render_js_component feedback_attribute
    render partial: "feedback_forms/attribute_types/js_components/#{feedback_attribute.type.name.downcase}", :locals => {attribute: feedback_attribute}
  end
end
