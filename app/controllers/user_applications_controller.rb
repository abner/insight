#encoding: UTF-8
class UserApplicationsController < ProtectedController
  before_filter :define_breadcrumbs, :only => [:show, :edit]
  helper_method :render_code, :render_js_include

  def index
    @user_applications = current_user.user_applications
  end

  def new
    @user_application = current_user.user_applications.new
  end

  def show
    @user_application = user_application
  end

  def edit
    @user_application = user_application
    add_breadcrumb  t('Edit')
  end

  def create
    @user_application =  current_user.user_applications.build(user_application_params)
    if @user_application.save
      flash[:notice] = translate('User application created!')
      redirect_to :action => :index
    else
      render :new
    end
  end

  def update
    if user_application.update_attributes(user_application_params)
        flash[:notice] = translate('User application changed successfully!')
        redirect_to :action => :index
    else
      render :edit
    end
  end

  def destroy
    user_application.destroy
    flash[:notice] = translate('User application removed successfully!')
    redirect_to :action => :index
  end

protected
  def render_code user_application
    render_to_string(:partial => 'feedback_js_code', :layout => false, :locals => {:user_application => user_application})
  end

  def render_js_include
    render_to_string(:partial => 'feedback_js_include', :layout => false)
  end
private
  def user_application
    current_user.user_applications.find(id_param)
  end

  def define_breadcrumbs
    add_breadcrumb  user_application
  end

  def id_param
    params[:id]
  end

  def user_application_params
    params.require(:user_application).permit :name
    # if current_user.nil? # Guest
    #   # Remove all keys from params[:user] except :name, :email, :password, and :password_confirmation
    #   params.require(:user_application).permit :name
    # elsif current_user.has_role :admin
    #   params.require(:user_application).permit! # Allow all user parameters
    # elsif current_user.has_role :user
    #   params.require(:user_application).permit :name
    # end
  end
end
