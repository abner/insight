#encoding: UTF-8
class UserApplicationsController < ProtectedController
  def index
    @user_applications = current_user.user_applications
  end

  def new
    @user_application = current_user.user_applications.new
  end

  def show
    @user_application = current_user.user_applications.find(id_param)
    add_breadcrumb  @user_application
  end

  def edit
    @user_application = current_user.user_applications.find(id_param)

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
    @user_application = current_user.user_applications.find(id_param)
    if @user_application.update_attributes(user_application_params)
        flash[:notice] = translate('User application changed successfully!')
        redirect_to :action => :index
    else
      render :edit
    end
  end

  def destroy
    @user_application = current_user.user_applications.find(id_param)
    @user_application.destroy
    flash[:notice] = translate('User application removed successfully!')
    redirect_to :action => :index
  end

private
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
