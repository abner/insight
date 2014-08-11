class ProtectedController < ApplicationController
  before_filter :authenticate_user!
  #after_action :verify_authorized

  def index
    #current_user.ldap_get_param(current_user.login_with, 'email')
    puts current_user.ldap_entry.inspect
    puts current_user.ldap_get_param(:mail)
    render text: "<h1>Protected</h1><p>#{current_user.ldap_dn}</p>"
  end
end
