class FeedbacksController < ProtectedController
  respond_to :html, :json, :js

  before_filter :define_breadcrumbs_index , :only => [:index]

  def index
    @feedback_form = @feedback_target.feedback_forms.find(params[:feedback_form_id])
    authorize!(:list_feedbacks, @feedback_form) do
      @feedbacks = list_feedbacks

      respond_to do |format|
        format.html { render :index }
        format.json { render json: FeedbacksDatatable.new(view_context) }
        format.js { render 'index.js.erb' }
      end
    end
  end

  def fire_event
    @feedback = feedback_from_params
    error = nil
    event = params[:event]
    begin
      unless @feedback.state_machine.fire_state_event(params[:event])
        error = 'invalid_transition'
      end
    rescue Exception => e
      error = "error_on_state_machine_evet"
    end
    respond_to do |format|
      if error
        result = respond_error_json({ message: I18n.t(error, event), object:  @feedback})
      else
        result = respond_success_json({ message: error, object:  @feedback})
      end
      render :json =>  result
    end
  end

  def comments
    begin
      @feedback = feedback_from_params
      @comments = @feedback.comments
      respond_to do |format|
        format.js {}
        format.html { render :partial => 'feedbacks/comments_list', :locals => { feedback: @feedback} }
        format.json { render :json =>  respond_success_json(:object => @comments) }
      end
    rescue Exception => ex
      respond_to do |format|
        format.html { render :partial => :comments_list, :locals => { feedback: @feedback} }
      end
    end
  end

  def add_comment
    @feedback = feedback_from_params
    @comment = @feedback.comments.create(:user => current_user, :text => params[:comment][:text])
    respond_to do |format|
      format.html { redirect_to action: :index }
      format.json do
        begin
          @feedback.save!
          render :json => respond_success_json(:object => @comment)
        rescue Exception => e
          render json: respond_error_json(:message => e.message ,:object => @feedback), :content_type => 'application/javascript'
        end
      end
      format.js do
        begin
          @feedback.save!
          @comment = Comment.new
          render :comments
        rescue Exception => e
          @error_message = e.message
          @controller_action = "feedbacks##{action_name}"
          render :comment_error
        end
      end
    end
  end

  def destroy_comment
    begin
      @feedback = feedback_from_params
      @comment = @feedback.comments.find(params[:comment_id])
      @comment.destroy
      @comment = Comment.new
      respond_to do |format|
        format.html { redirect_to action: :index }
        format.json { render :json => respond_success_json(:object => @comment) }
        format.js   { render :comments }
      end
    rescue Exception => e
      respond_to do |format|
        format.html { redirect_to :index}
        format.json { render json: respond_error_json(:message => e.message ,:object => @feedback), :content_type => 'application/javascript'}
        format.js   { render :comments }
      end
    end
  end

  def archive
    @feedback = nil
    @scope = 'default'

    @feedback = feedback_from_params
    @feedback.archive!
    respond_to do |format|
      format.html do
        redirect_to action: :index
      end
      format.js do
        begin
          redirect_to feedback_target_feedback_form_feedbacks_path(@feedback_target, @feedback.feedback_form, view_context.pagination_params)
        rescue Exception => e
          render json: respond_error_json(:message => e.message ,:object => @feedback), :content_type => 'application/javascript'
        end
      end
    end
  end

  def unarchive
    @feedback = nil
    @scope = 'archived'

    @feedback = feedback_from_params
    @feedback.unarchive!

    respond_to do |format|
      format.html { redirect_to action: :index }
      format.js do
        redirect_to feedback_target_feedback_form_feedbacks_path(@feedback_target, @feedback.feedback_form, view_context.pagination_params.merge(:scope => 'archived'))
      end
    end
  end

protected

  def list_feedbacks
    @feedback_target = current_user.my_targets.find(params[:feedback_target_id])

    if params[:feedback_form_id]
      @feedback_form = @feedback_target.feedback_forms.find(params[:feedback_form_id])
    else
      @feedback_form = nil
    end


    @page = params[:page] || 1

    @per_page = params[:per_page] || Feedback.per_page

    @scope = params['scope'] || 'default'

    feedbacks = []

    if @feedback_form
      feedbacks_relation = @feedback_form.feedbacks
    else
      feedbacks_relation = @feedback_target.feedbacks
    end

    if 'default'.eql? @scope
      feedbacks = feedbacks_relation.order(server_date_time: 'DESC').paginate(page: @page, per_page: @per_page)
      if feedbacks.empty?
        feedbacks = feedbacks_relation.order(server_date_time: 'DESC').paginate(page: 1, per_page: @per_page)
      end
    elsif 'archived'.eql? @scope
      feedbacks = feedbacks_relation.archived.order(server_date_time: 'DESC').paginate(page: @page, per_page: @per_page)
      if feedbacks.empty?
        feedbacks = feedbacks_relation.archived.order(server_date_time: 'DESC').paginate(page: 1, per_page: @per_page)
      end
    end

    feedbacks

  end
  def feedback_from_params
    if 'archived'.eql? @scope
      @feedback ||= feedback_target.feedbacks.archived.find params[:id]
    else
      @feedback ||= feedback_target.feedbacks.find params[:id]
    end
  end
  def feedback_target
    @feedback_target ||= FeedbackTarget.all_targets_for_user(current_user).find(feedback_target_id_param)
  end

  def feedback_target_id_param
    params[:feedback_target_id]
  end

  private
    def define_breadcrumbs_index
      add_breadcrumb  feedback_target
      @feedback_form = @feedback_target.feedback_forms.find(params[:feedback_form_id])
      add_breadcrumb  @feedback_form.name,feedback_target_feedback_form_path(@feedback_target, @feedback_form)
      add_breadcrumb  'Feedbacks'
    end
end
