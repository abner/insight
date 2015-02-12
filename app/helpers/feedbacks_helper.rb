module FeedbacksHelper

  def all_columns_for_collection(collection)
    arr_column_names = collection.map do |f|
        f.columns.collect {|c| c[:key] }
    end
    result = arr_column_names.flatten!
    return [] if result.nil?
    result.uniq.nil? ? result : result.uniq
  end

  def show_column_value(column_name, value)
    return '' if value.nil?
    #puts "Tipo: #{value.class.name} - value: #{value}"
    if 'screenshot_path'.eql?(column_name)
      #tag 'img', :src => "/" + url_for(value), :width => 150, height: 80
      link_to(
            raw(content_tag(:span, pad(translate('Screenshot')), :class => 'fa fa-camera')),
            url_for( "/" + value),
            :class => 'screenshot_link')
    elsif value.is_a? Time
      l value, :format => '%d/%m/%y %H:%M'
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
end
