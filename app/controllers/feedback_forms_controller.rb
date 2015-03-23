class FeedbackFormsController < ProtectedController

  before_filter :authenticate_user!, :except => [:code]

  protect_from_forgery with: :exception, :except => [:code]
  respond_to :js, :html, :json

  before_filter :define_breadcrumbs_form, :only => [:show, :edit]
  before_filter :define_breadcrumbs_index , :only => [:index]

  def new
    @feedback_target = find_feedback_target
    authorize!(:create_feedback_form, @feedback_target) do
      @feedback_form = @feedback_target.feedback_forms.new
      @feedback_form.feedback_attributes.build
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

  def new_attribute
    @feedback_target = find_feedback_target
    @feedback_form = find_feedback_for @feedback_target
    authorize!(:write_feedback_form, @feedback_form) do
      @attribute = @feedback_form.attributes.new
    end
  end

  def create
    @feedback_target = find_feedback_target
    authorize!(:create_feedback_form, @feedback_target) do
      @feedback_form = @feedback_target.feedback_forms.create feedback_form_params
      respond_to do |format|
        format.html do
          if @feedback_form.persisted?
            redirect_to action: :index
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

        #raise @feedback_form.feedback_attributes.inspect

        # params[:feedback_form][:feedback_attributes_attributes].values.each_with_index do |attribute_hash, index|
        #   feedback_attribute = @feedback_form.feedback_attributes.find_or_initialize_by(id: attribute_hash[:id])
        #   feedback_attribute.position = index #attribute_hash[:position]
        #   feedback_attribute.type_id = attribute_hash[:type_id]
        #   feedback_attribute.name = attribute_hash[:name]
        #   feedback_attribute.display_label = attribute_hash[:display_label]
        #   feedback_attribute.options = attribute_hash[:options]
        #   feedback_attribute.default_value = attribute_hash[:default_value]
        # end

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
    authorize!(:destroy_feedback_form, @feedback_form) do
      @feedback_form.destroy
    end
    respond_to do |format|
      format.html { redirect_to action: :index }
      format.js do
        @feedback_target = find_feedback_target
        @feedback_forms = @feedback_target.feedback_forms
        render :index
       end
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
    FeedbackTarget.all_targets_for_user(current_user).find(feedback_target_id_param)
  end

  def feedback_target_id_param
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
    add_breadcrumb  feedback_target.name, feedback_target_path(feedback_target)
    add_breadcrumb  'Feedback Forms', feedback_target_feedback_forms_path(feedback_target)
    feedback_form =  find_feedback_for(feedback_target)
    add_breadcrumb feedback_form.name,  feedback_target_feedback_form_path(feedback_target,feedback_form)
  end

  def define_breadcrumbs_index
    feedback_target = find_feedback_target
    add_breadcrumb  feedback_target.name, feedback_target_path(feedback_target)
    add_breadcrumb  'Feedback Forms'
  end

  def feedback_form_params
    params.require(:feedback_form).permit :name, :description_field_name,
      :screenshot_enabled,
      :review_enabled,
      :initial_state,
      :state_field,
      :state_field_label,
      :feedback_attributes_attributes => [:id, :name, :display_label, :_destroy, :options, :default_value, :position, :type_id],
      :grid_columns => [],
      :detail_columns => [],
      :state_transitions_attributes => [:id, :state, :action, :result_state, :_destroy]
  end





end
