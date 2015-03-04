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

  def show_column_value(column_name, value)
    return raw '&nbsp;' if value.nil?
    return raw '&nbsp;' if value.is_a?(String) and value.empty?
    #puts "Tipo: #{value.class.name} - value: #{value}"
    if 'screenshot_path'.eql?(column_name)
      #tag 'img', :src => "/" + url_for(value), :width => 150, height: 80
      link_to(
            raw(content_tag(:span, pad(translate('Screenshot')), :class => 'fa fa-camera')),
            url_for( "/" + value),
            :class => 'screenshot_link')
    elsif value.is_a? Time
      l value.in_time_zone, :format => '%d/%m/%y %H:%M'
    else
      value.to_s
    end
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
        archive_user_application_feedback_path(@user_application, feedback, pagination_params),
        :method=> 'POST', :remote => true, :data => {:confirm => t('feedback.archive_confirmation_question'),
        :type => 'script', :target_selector => 'a'}
        ) do
            raw("<i class='fa fa-trash-o'></i>") +
            content_tag(:span, pad(t('Archive')))
        end
    end
  end

  def link_to_unarchive feedback
    if current_user_can?(:unarchive_feedback, feedback)
      link_to(
        unarchive_user_application_feedback_path(@user_application, feedback, pagination_params),
        :method=> 'POST', :remote => true, :data => {:confirm => t('feedback.unarchive_confirmation_question'),
        :type => 'script', :target_selector => 'a'}
        ) do
          content_tag(:span, pad(t('Unarchive')), :class => 'fa fa-trash-o')
        end
    end
  end

  def id_for_panel_feedback_detail feedback
    "feedback_detail_#{feedback.id}"
  end
end
