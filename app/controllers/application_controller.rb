#encoding: UTF-8
class ApplicationController < ActionController::Base
  #layout 'bootstrap_layout'
  layout 'layout2'
  
  #add_breadcrumb 'Início', root_path
 before_action :configure_permitted_parameters, if: :devise_controller?
  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render :text => exception, :status => 500
  end
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  before_filter :define_locale, :breadcrumb


  def breadcrumb
    add_breadcrumb 'Início', feedback_targets_path
  end

  def define_locale
    I18n.locale = :'pt-BR'
  end

 protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) {|u| u.permit(:signin)}
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:email, :username, :password, :password_confirmation)}
  end

  def after_sign_in_path_for(resource)
    feedback_targets_path
  end

  def respond_success_json(args={})
    {
      :success => true,
      :action => args[:action] || action_name,
      :data => args[:object]
    }.to_json
  end

  def respond_error_json(args = {})
    {
      :error => true,
      :error_message => args[:message],
      :action => args[:action] || action_name,
      :data => args[:object]
    }.to_json
  end

end
