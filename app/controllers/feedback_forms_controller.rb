class FeedbackFormsController < ProtectedController
  protect_from_forgery with: :exception, :except => [:code]
  respond_to :js, :html, :json

  before_filter :define_breadcrumbs_form, :only => [:show, :edit]
  before_filter :define_breadcrumbs_index , :only => [:index]

  def new
    @feedback_target = find_feedback_target
    authorize!(:create_feedback_form, @feedback_target) do
      @feedback_form = @feedback_target.feedback_forms.new
    end
  end

  def code
    @feedback_form = FeedbackForm.find_by(authentication_token: params[:token])

    render :code, :layout => false, content_type: 'text/javascript'
  end

  def index
    @feedback_target = find_feedback_target
    authorize!(:list_feedback_forms, @feedback_target) do
      #TODO add pagination
      @feedback_forms = @feedback_target.feedback_forms
    end
  end

  def show
    @feedback_target = find_feedback_target
    @feedback_form = find_feedback_for @feedback_target
    authorize!(:read_feedback_form, @feedback_form)
  end

  def create
    @feedback_target = find_feedback_target
    authorize!(:create_feedback_form, @feedback_target) do
      @feedback_form = @feedback_target.feedback_forms.create feedback_form_params
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
    @feedback_target = find_feedback_target
    @feedback_form = find_feedback_for(@feedback_target)
    authorize!(:write_feedback_form, @feedback_form)
  end

  def update
    @feedback_target = find_feedback_target
    @feedback_form = find_feedback_for(@feedback_target)
    authorize!(:write_feedback_form, @feedback_form) do
      respond_to do |format|
        @feedback_form.attributes = feedback_form_params

        params[:feedback_form][:feedback_attributes_attributes].values.each do |attribute_hash|
          feedback_attribute = @feedback_form.feedback_attributes.find(attribute_hash[:id])
          feedback_attribute.position = attribute_hash[:position]
        end

        if @feedback_form.save
          format.html { redirect_to feedback_target_feedback_forms_path(:action => index) }
        else
          format.html { render :edit }
        end
      end
    end
  end

  def destroy
    @feedback_target = find_feedback_target
    @feedback_form = find_feedback_for(@feedback_target)
    authorize!(:write_feedback_form, @feedback_form) do
      @feedback_form.destroy
    end
  end

protected

  def find_feedback_for(feedback_target)
    if 'default'.eql? params[:id]
      return feedback_target.default_feedback_form
    elsif params[:id]
      return feedback_target.feedback_forms.find(params[:id])
    end
  end

  def find_feedback_target
    FeedbackTarget.all_apps_for_user(current_user).find(user_applciation_id_param)
  end

  def user_applciation_id_param
    params[:feedback_target_id]
  end


    def apply_pagination
      #@collection_resources
    end

    def apply_scope
      #collection_resources
    end

private

  def define_breadcrumbs_form
    feedback_target = find_feedback_target
    add_breadcrumb  feedback_target
    add_breadcrumb  'Feedback Forms', feedback_target_feedback_forms_path(feedback_target)
    feedback_form =  find_feedback_for(feedback_target)
    add_breadcrumb feedback_form.name,  feedback_target_feedback_form_path(feedback_target,feedback_form)
  end

  def define_breadcrumbs_index
    add_breadcrumb  find_feedback_target
    add_breadcrumb  'Feedback Forms'
  end

  def feedback_form_params
    params.require(:feedback_form).permit :name,
      :screenshot_enabled,
      :review_enabled,
      { :grid_columns => [], :detail_columns => []}
  end





end
