class FeedbackFormsController < ProtectedController

  before_action :load_resources, except: [:new]
  respond_to :js, :html, :json

  def new
    authorize!(:create_feedback_form, user_application) do
      @feedback_form = user_application.feedback_forms.new
    end
  end

  def index
    authorize!(:list_feedback_forms, @user_application)
  end

  def show
    authorize!(:read_feedback_form, @feedback_form)
  end

  def create
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
    authorize!(:write_feedback_form, @feedback_form)
  end

  def update
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
    authorize!(:write_feedback_form, @feedback_form) do
      @feedback_form.destroy
    end
  end

protected
  def load_resources
    @feedback_forms = user_application.feedback_forms
    if 'default'.eql? params[:id]
      @feedback_form = user_application.default_feedback_form
    elsif params[:id]
      @feedback_form = user_application.feedback_forms.find(params[:id])
    end
  end

private

  def feedback_form_params
    params.require(:feedback_form).permit :name,
      :screenshot_enabled,
      :review_enabled,
      { :grid_columns => [], :detail_columns => [] }
  end

  def apply_pagination
    #@collection_resources
  end

  def apply_scope
    #collection_resources
  end


  def user_application
    @user_application ||= UserApplication.all_apps_for_user(current_user).find(user_applciation_id_param)
  end

  def user_applciation_id_param
    params[:user_application_id]
  end

end
