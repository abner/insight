module UserHelper
  def authenticate_user!
    # We can't just call authenticate_directory/database_user directly; if we're authenticated with one and we
    # call the other, we'll be logged out.
    if registered_user_signed_in?
      authenticate_registered_user!
    else
      authenticate_ldap_user!
    end
  end

  def current_user
    current_ldap_user or current_registered_user
  end
end

