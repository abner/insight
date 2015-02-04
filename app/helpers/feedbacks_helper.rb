module FeedbacksHelper

  def all_columns_for_collection(collection)
    arr_column_names = collection.map do |f|
        f.columns.collect {|c| c[:key] }
    end
    result = arr_column_names.flatten!
    result.uniq.nil? ? result : result.uniq
  end

  def show_column_value(column_name, value)
    #puts "Tipo: #{value.class.name} - value: #{value}"
    if 'screenshot_path'.eql?(column_name)
      tag 'img', :src => "/" + url_for(value), :width => 150, height: 80
    elsif value.is_a? Time
      l value, :format => '%d/%m/%y %H:%M'
    else
      if value.nil?
        return ""
      else
        return value.to_s
      end
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
