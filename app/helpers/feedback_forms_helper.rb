module FeedbackFormsHelper
  def actions_for feedback_form
    actions = []

    if current_user_can?(:write_feedback_form, feedback_form)
      actions <<
              link_to(
                edit_user_application_feedback_form_path(feedback_form.user_application, feedback_form)
                ) do
                    content_tag(:span, pad(t('Edit')), class: 'fa fa-edit')
                  end
    end
    actions << "&nbsp;"
    actions <<
              link_to(user_application_feedback_form_feedbacks_path(feedback_form.user_application, feedback_form)) do
                content_tag(:span, pad(translate('Feedbacks')) + " ", :class => 'fa fa-comment-o')
              end
    raw actions.join
  end

  def url_for_form(user_application, feedback_form)
    if feedback_form.new_record?
      user_application_feedback_forms_path(user_application)
    else
      user_application_feedback_form_path(user_application, feedback_form)
    end
  end

  def render_js_component feedback_attribute
    render partial: "feedback_forms/attribute_types/js_components/#{feedback_attribute.type.name.downcase}", :locals => {attribute: feedback_attribute}
  end
end
