class SessionsController < Devise::SessionsController
layout 'login_page'
  def create
    user_class = nil

    # Copy user data to ldap_user and local_user
    request.params['ldap_user'] = request.params['registered_user'] = request.params['user']

    user = User.where(username: request.params['user']['username']).first

    if user.is_a? LdapUser
      # Try to authenticate as a directory user.
      user_class = :ldap_user
    elsif user.is_a? RegisteredUser
      # Try to authenticate as a database user.
      user_class = :registered_user
    elsif user.nil?
      user_class = :ldap_user
    end

    puts user_class.to_s

    # Use Warden to authenticate the user, if we get nil back, it failed.
    begin
      self.resource = warden.authenticate scope: user_class
    rescue Exception => e
      puts "Here"
        Rails.logger.error("Session create error: #{e.inspect}")
       flash[:error] = t('sessions.create.error') + "\n#{e.inspect}"
       return redirect_to new_session_path
    end

    if self.resource.nil?
      flash[:error] = t 'sessions.create.failure'
      return redirect_to new_session_path
    end


    # Now we know the user is authenticated, sign them in to the site with Devise
    # At this point, self.resource is a valid user account.
    if user_class == :registered_user
      sign_in(user_class, self.resource)
    end

    respond_with self.resource, :location => after_sign_in_path_for(self.resource)
  end

  def destroy
    sign_out
    #set_flash_message :notice, :signed_out if sign_out && is_navigational_format?

    # We actually need to hardcode this as Rails default responder doesn't
    # support returning empty response on GET request
    respond_to do |format|
      format.all { head :no_content }
      format.any(*navigational_formats) { redirect_to new_session_path }
    end
  end

  def new
    redirect_to '/user_applications'  if  registered_user_signed_in? || ldap_user_signed_in?
    # Set up a blank resource for the view rendering
    self.resource = User.new
  end

private
  def type_of_user(user_hash)
    if('ldap_user'.eql?(user_hash[:type_user]))
      return :ldap_user
    else
      return :registered_user
    end
  end
end
