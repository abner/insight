class FeedbacksController < ProtectedController
  respond_to :html, :json, :js

  def index
    @feedbacks = list_feedbacks
    add_breadcrumb @feedback_target
    add_breadcrumb 'Feedbacks', feedback_target_feedbacks_path(@feedback_target)
    respond_to do |format|
      format.html { render :index }
      format.json { render json: FeedbacksDatatable.new(view_context) }
      format.js { render 'index.js.erb' }
    end
  end

  def comments
    begin
      @feedback = feedback_from_params
      @comments = @feedback.comments
      respond_to do |format|
        format.js {}
        format.html {}
        format.json { render :json =>  respond_success_json(:object => @comments) }
      end
    rescue Exception => ex

    end
  end

  def add_comment
    respond_to do |format|
      format.json do
        begin
          @feedback = feedback_from_params
          @comment = @feedback.comments.create(:user => current_user, :text => params[:comment][:text])
          @feedback.save!
          render :json => respond_success_json(:object => @comment)
        rescue Exception => e
          render json: respond_error_json(:message => e.message ,:object => @feedback), :content_type => 'application/javascript'
        end
      end
      format.js do
        begin
          @feedback = feedback_from_params
          @feedback.comments.create(:user => current_user, :text => params[:comment][:text])
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
    respond_to do |format|
      format.json do
        begin
          @feedback = feedback_from_params
          @comment = @feedback.comments.find(params[:comment_id])
          @comment.destroy
          render :json => respond_success_json(:object => @comment)
        rescue Exception => e
          render json: respond_error_json(:message => e.message ,:object => @feedback), :content_type => 'application/javascript'
        end
      end
      format.js do
        @feedback = feedback_from_params
        @feedback.comments.find(params[:comment_id]).destroy()
        render :comments
      end
    end
  end

  def archive
    @feedback = nil
    @scope = 'default'

    respond_to do |format|
      format.html
      format.js do
        begin
          @feedback = feedback_from_params
          @feedback.archive!
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

    respond_to do |format|
      format.html
      format.js do
        @feedback = feedback_from_params
        @feedback.unarchive!
        redirect_to feedback_target_feedback_form_feedbacks_path(@feedback_target, @feedback.feedback_form, view_context.pagination_params.merge(:scope => 'archived'))
      end
    end
  end

protected

  def load_resources
    @feedback = feedback_from_params
  end

  def list_feedbacks
    @feedback_target = current_user.my_apps.find(params[:feedback_target_id])

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
    @feedback_target ||= FeedbackTarget.all_targets_for_user(current_user).find(user_applciation_id_param)
  end

  def user_applciation_id_param
    params[:feedback_target_id]
  end
end
