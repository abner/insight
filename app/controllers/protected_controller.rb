class ProtectedController < ApplicationController
  include UserHelper

  before_filter :authenticate_user!#, :unless => :devise_controller?
  #after_action :verify_authorized

  helper_method :abilities, :can?, :authorize!, :current_user_can?

  def index

    #puts current_user.public_methods.sort.inspect
    render text: "<h1>Protected</h1><div style='width=840px'>#{current_user.ldap_entry.inspect}</div>"
  end

protected
    # simple delegate method for controller & view
  def can?(user, action, subject)
    Ability.abilities.allowed?(user, action, subject)
  end

  def current_user_can?(action, subject)
    Ability.abilities.allowed?(current_user, action, subject)
  end

  def authorize!(action, subject)
    if Ability.abilities.allowed?(current_user, action, subject)
      yield
    else
      return access_denied!
    end
  end

  def access_denied!
    render "errors/access_denied", layout: "errors", status: 403
  end
end
