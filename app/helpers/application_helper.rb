module ApplicationHelper
  def pad( random )
    " " + random + " "
  end

  def app_base_url
    if(Rails.env.eql? 'production')
      request.protocol + Rails.application.config.app_host
    else
      request.base_url
    end
  end
end
