module ApplicationHelper
  def pad( random )
    " " + random + " "
  end

  def app_base_url
    if(Rails.env.eql? 'production')
      '//' + Rails.application.config.app_host
    else
      request.base_url
    end
  end

  def page_filter_path(options={})
    exist_opts = {
      state: params[:state],
      scope: params[:scope],
      #label_name: params[:label_name],
      #milestone_id: params[:milestone_id],
      assignee_id: params[:assignee_id],
      assignee_to_me: params[:assignee_to_me],
      #author_id: params[:author_id],
      sort: params[:sort],
    }

    options = exist_opts.merge(options)

    path = request.path
    path << "?#{options.to_param}"
    path
  end

  def wrapper_div
    if "true".eql? cookies['feedback_menu_collapsed']
      css_class = 'main_wrapper collapsed'
    else
      css_class = 'main_wrapper'
    end
    content_tag :div, :id => 'wrapper', :class => css_class do
      yield
    end
  end

  def serpro_logo
    if "true".eql? cookies['feedback_menu_collapsed']
      css_class = 'logo_serpro_50_anos collapsed'
    else
      css_class = 'logo_serpro_50_anos'
    end
    content_tag :div, '', :class => css_class
  end

  def layout(layout_name)
    controller.class.send(:layout, layout_name)
  end

  def render_action(action_name, model)
    model_class = controller.model_name_from_record_or_class(model)
    model_key = model_class.element.to_sym
    render partial: "#{controller_name}/actions/#{action_name}", locals: {model_key => model}
  end

end
