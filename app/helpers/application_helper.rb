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
