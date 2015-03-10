class SessionsController < Devise::SessionsController

  respond_to :html
  skip_before_filter :verify_authenticity_token

layout 'login_page'
  def create
    user_class = nil

    if auth_hash
      omniauth_authentication
    else
      devise_authentication
    end
  end

  def omniauth_failure
    flash[:error] = t 'devise.sessions.create.failure'
    redirect_to '/sign_in'
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
    #redirect_to '/feedback_targets'  if  registered_user_signed_in? || ldap_user_signed_in?
    redirect_to '/feedback_targets'  if  registered_user_signed_in? || expresso_user_signed_in?
    # Set up a blank resource for the view rendering
    self.resource = User.new
    #resource_name = :expresso_user
  end

private

  def omniauth_authentication
    @user = ExpressoUser.from_omniauth(auth_hash)

    if(@user.persisted?)
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Expresso") if is_navigational_format?
    else
      session["devise.expresso_data"] = request.env["omniauth.auth"].except("extra")
      redirect_to '/'
    end
  end

  def auth_hash
    request.env['omniauth.auth']
  end

  def devise_authentication
    unless request.params['user']
      request.params['user'] = {}
      request.params['user']['username'] = request.params['username'] if request.params['username']
      request.params['user']['password'] = request.params['password'] if request.params['password']
    end
    # Copy user data to ldap_user and local_user
    request.params['ldap_user'] = request.params['registered_user'] = request.params['user']

    user = User.where(username: request.params['user']['username']).first

    user_class = define_user(user)


    # Use Warden to authenticate the user, if we get nil back, it failed.
    begin
      self.resource = warden.authenticate scope: user_class
    rescue Exception => e
      Rails.logger.error("Session create error: #{e.inspect}")
       flash[:error] = t('sessions.create.error') + "\n#{e.inspect}"
       return redirect_to new_session_path
    end

    if self.resource.nil?
      flash[:error] = t 'devise.sessions.create.failure'
      return redirect_to new_session_path
    end


    # Now we know the user is authenticated, sign them in to the site with Devise
    # At this point, self.resource is a valid user account.
    if user_class == :registered_user
      sign_in(user_class, self.resource)
    end

    redirect_to after_sign_in_path_for(self.resource)
    #respond_with self.resource, :location => after_sign_in_path_for(self.resource)
  end

  def define_user user
    if Rails.application.config.ldap_enabled
      if user.is_a? LdapUser
        # Try to authenticate as a directory user.
        user_class = :ldap_user
      elsif user.is_a? RegisteredUser
        # Try to authenticate as a database user.
        user_class = :registered_user
      elsif user.nil?
        user_class = :ldap_user
      end
    else
      if user.is_a? ExpressoUser
        # Try to authenticate as a directory user.
        user_class = :expresso_user
      elsif user.is_a? RegisteredUser
        # Try to authenticate as a database user.
        user_class = :registered_user
      elsif user.nil?
        user_class = :expresso_user
      end
    end
  end

  def type_of_user(user_hash)
    if('ldap_user'.eql?(user_hash[:type_user]))
      return :ldap_user
    else
      return :registered_user
    end
  end
end
