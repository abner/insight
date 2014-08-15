class ProtectedController < ApplicationController
  before_filter :authenticate_user!
  #after_action :verify_authorized

  def index

    #puts current_user.public_methods.sort.inspect
    render text: "<h1>Protected</h1><div style='width=840px'>#{current_user.ldap_entry.inspect}</div>"
  end
end
