module SortingHelper

  def sort_options_hash(feedback_form)
    sort_hash = {}

    feedback_form.feedback_attributes.each do |attribute|
      sort_hash["#{attribute.name}.asc"] = "#{attribute.display_label} #{I18n.t('ascending')}"
      sort_hash["#{attribute.name}.desc"] = "#{attribute.display_label} #{I18n.t('descending')}"
    end
    sort_hash
  end

  def sort_argument_from_param(params)
    # params[:sort] expected to be a comma separeted list
    # like relato.asc, created_at.asc
    params ||= {}
    if params[:sort]
      sort_args = params[:sort].split(',')
      # this will map to an array like [:relato.asc, :created_at.asc]
      return sort_args.map do |sort_arg|
        arr = sort_arg.split('.')
        if arr.count == 2 and %w(asc desc).include?(arr[1])
          arr[0].to_sym.send(arr[1])
        end
      end
    end
  end

end
