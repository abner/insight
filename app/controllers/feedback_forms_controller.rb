class FeedbackFormsController < ProtectedController

  respond_to :js, :html, :json

  def new
    @user_application = find_user_application
    authorize!(:create_feedback_form, @user_application) do
      @feedback_form = @user_application.feedback_forms.new
    end
  end

  def index
    @user_application = find_user_application
    authorize!(:list_feedback_forms, @user_application) do
      #TODO add pagination
      @feedback_forms = @user_application.feedback_forms
    end
  end

  def show
    @user_application = find_user_application
    @feedback_form = find_feedback_for @user_application
    authorize!(:read_feedback_form, @feedback_form)
  end

  def create
    @user_application = find_user_application
    authorize!(:create_feedback_form, @user_application) do
      @feedback_form = @user_application.feedback_forms.create feedback_form_params
      respond_to do |format|
        format.html do
          if @feedback_form.persisted?
            redirect_to :index
          else
            render :new
          end
        end
      end
    end
  end

  def edit
    @user_application = find_user_application
    @feedback_form = find_feedback_for(@user_application)
    authorize!(:write_feedback_form, @feedback_form)
  end

  def update
    @user_application = find_user_application
    @feedback_form = find_feedback_for(@user_application)
    authorize!(:write_feedback_form, @feedback_form) do
      respond_to do |format|
        if @feedback_form.update_attributes feedback_form_params
          format.html { redirect_to user_application_feedback_forms_path(:action => index) }
        else
          format.html { render :edit }
        end
      end
    end
  end

  def destroy
    @user_application = find_user_application
    @feedback_form = find_feedback_for(@user_application)
    authorize!(:write_feedback_form, @feedback_form) do
      @feedback_form.destroy
    end
  end

protected

  def find_feedback_for(user_application)
    if 'default'.eql? params[:id]
      return user_application.default_feedback_form
    elsif params[:id]
      return user_application.feedback_forms.find(params[:id])
    end
  end

  def find_user_application
    UserApplication.all_apps_for_user(current_user).find(user_applciation_id_param)
  end

  def user_applciation_id_param
    params[:user_application_id]
  end


    def apply_pagination
      #@collection_resources
    end

    def apply_scope
      #collection_resources
    end

private

  def feedback_form_params
    params.require(:feedback_form).permit :name,
      :screenshot_enabled,
      :review_enabled,
      { :grid_columns => [], :detail_columns => [] }
  end





end
