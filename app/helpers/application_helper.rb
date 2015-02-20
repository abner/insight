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

end
