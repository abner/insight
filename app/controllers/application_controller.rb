#encoding: UTF-8
class ApplicationController < ActionController::Base
  layout 'bootstrap_layout'
  #add_breadcrumb 'Início', root_path

  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render :text => exception, :status => 500
  end
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :define_locale, :breadcrumb

  def breadcrumb
    add_breadcrumb 'Início', user_applications_path
  end

  def define_locale
    I18n.locale = :pt
  end
end
