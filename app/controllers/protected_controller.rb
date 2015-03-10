class ProtectedController < ApplicationController
  include UserHelper

  before_filter :authenticate_user!#, :unless => :devise_controller?
  #after_action :verify_authorized

  helper_method :abilities, :can?, :authorize!, :current_user_can?

protected

  # not necessary yet
  # simple delegate method for controller & view
  # def can?(user, action, subject)
  #   Ability.abilities.allowed?(user, action, subject)
  # end

  def current_user_can?(action, subject)
    Ability.abilities.allowed?(current_user, action, subject)
  end

  def authorize!(action, subject)
    if Ability.abilities.allowed?(current_user, action, subject)
      yield if block_given?
    else
      return access_denied!
    end
  end

  def access_denied!
    #render "errors/access_denied", layout: "errors", status: 403
    render "errors/access_denied", status: 403
  end
end
