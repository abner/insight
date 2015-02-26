class FeedbacksController < ProtectedController


  def index
    @feedbacks = list_feedbacks
    add_breadcrumb @user_application
    add_breadcrumb 'Feedbacks', user_application_feedbacks_path(@user_application)
    respond_to do |format|
      format.html
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
          redirect_to user_application_feedbacks_path(@user_application, view_context.pagination_params)
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
        redirect_to user_application_feedbacks_path(@user_application, view_context.pagination_params.merge(:scope => 'archived'))
      end
    end
  end

protected
  def list_feedbacks
    @user_application = current_user.my_apps.find(params[:user_application_id])

    if params[:feedback_form_id]
      @feedback_form = @user_application.feedback_forms.find(params[:feedback_form_id])
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
      feedbacks_relation = @user_application.feedbacks
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
      @feedback ||= user_application.feedbacks.archived.find params[:id]
    else
      @feedback ||= user_application.feedbacks.find params[:id]
    end
  end
  def user_application
    @user_application ||= UserApplication.all_apps_for_user(current_user).find(user_applciation_id_param)
  end

  def user_applciation_id_param
    params[:user_application_id]
  end
end
