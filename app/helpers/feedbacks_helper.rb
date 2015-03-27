module FeedbacksHelper

  def all_columns_for feedback
    columns = feedback.columns.collect {|c| c[:key] }
    columns.delete 'comments'
    columns
  end

  def all_columns_for_collection(collection)
    arr_column_names = collection.map do |f|
        f.columns.collect {|c| c[:key] }
    end
    result = arr_column_names.flatten!
    return [] if result.nil?
    result = result.uniq.nil? ? result : result.uniq
    result.delete 'comments'
    result
  end

  def show_column_value(feedback, column_name)
    value =  feedback.read_attribute(column_name)
    return raw '&nbsp;' if (value.is_a?(String) and value.empty?) or value.nil?
    #puts "Tipo: #{value.class.name} - value: #{value}"
    if 'screenshot_path'.eql?(column_name)
      #tag 'img', :src => "/" + url_for(value), :width => 150, height: 80
      return link_to(
            raw(content_tag(:span, pad(translate('Screenshot')), :class => 'fa fa-camera')),
            url_for( "/" + value),
            :class => 'screenshot_link')
    elsif value.is_a? Time
      return l value.in_time_zone, :format => '%d/%m/%y %H:%M'
    else
      result = value.to_s
    end
  end

  def feedback_url(feedback)
    feedback_target_feedback_form_feedback_path(feedback.feedback_target, feedback.feedback_form, feedback)
  end

  def fire_event_url(feedback, state_transition)
    fire_event_feedback_target_feedback_form_feedback_path(
      feedback.feedback_target,
      feedback.feedback_form,
      feedback, event: state_transition.event)
  end

  def link_to_feedback_transition(feedback ,state_transition, link_to_options={})
    link_text = state_transition.event.to_s.humanize
    url = fire_event_url(feedback,state_transition)
    options = { data: { remote: true, method: 'put', event: state_transition.event, feedback: feedback.id } }
    link_to(link_text, url, link_to_options.merge(options))
  end


  def humanize_column(column_name)
    return "" if column_name.nil?
    if column_name.is_a?(String)
      return column_name.humanize
    else
      return column_name.to_s
    end
  end

  def pagination_params
    pagination_hash = {}
    if(params[:per_page])
      pagination_hash[:per_page] = params[:per_page]
    end
    if(params[:page])
      pagination_hash[:page] = params[:page]
    end
    pagination_hash
  end

  def link_to_archive feedback
    if current_user_can?(:archive_feedback, feedback)
      link_to(
        archive_feedback_target_feedback_form_feedback_path(@feedback_target, feedback.feedback_form,feedback, pagination_params),
        :method=> 'POST', :remote => true, :data => {:confirm => t('feedback.archive_confirmation_question'),
        :type => 'script', :target_selector => 'a'}
        ) do
            raw("<i class='fa fa-archive-o'></i>") +
            content_tag(:span, pad(t('Archive')))
        end
    end
  end

  def link_to_unarchive feedback
    if current_user_can?(:unarchive_feedback, feedback)
      link_to(
        unarchive_feedback_target_feedback_form_feedback_path(@feedback_target, feedback.feedback_form,feedback, pagination_params),
        :method=> 'POST', :remote => true, :data => {:confirm => t('feedback.unarchive_confirmation_question'),
        :type => 'script', :target_selector => 'a'}
        ) do
          content_tag(:span, pad(t('Unarchive')), :class => 'fa fa-undo')
        end
    end
  end

  def show_detail_path feedback
    ft = feedback.feedback_target
    ff = feedback.feedback_form
    show_detail_feedback_target_feedback_form_feedback_path(ft, ff, feedback)
  end

  def id_for_panel_feedback_detail feedback
    "td_feedback_detail_#{feedback.id}"
  end

  def id_for_line_feedback_detail feedback
    "tr_feedback_detail_#{feedback.id}"
  end

  def feedback_detail_anchor feedback
    "feedback_detail_#{feedback.id}"
  end

  def state_filtered? state_name
    if params[:state].present?
      params[:state].include?(state_name.to_s)
    else
      return false
    end
  end

  def state_filtered_value(state_name)
    state_filtered?(state_name) ? 1 : 0
  end
end
