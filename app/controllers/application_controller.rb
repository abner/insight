class ApplicationController < ActionController::Base
  layout 'bootstrap_layout'
  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render :text => exception, :status => 500
  end
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :define_locale

  def define_locale
    I18n.locale = :pt
  end
end
