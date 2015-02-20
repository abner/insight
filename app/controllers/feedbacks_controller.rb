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

    @page = params[:page] || 1
    @per_page = params[:per_page] || Feedback.per_page

    @scope = params['scope'] || 'default'

    feedbacks = []

    if 'default'.eql? @scope
      feedbacks = @user_application.feedbacks.order(server_date_time: 'DESC').paginate(page: @page, per_page: @per_page)
      if feedbacks.empty?
        feedbacks = @user_application.feedbacks.order(server_date_time: 'DESC').paginate(page: 1, per_page: @per_page)
      end
    elsif 'archived'.eql? @scope
      feedbacks = @user_application.feedbacks.archived.order(server_date_time: 'DESC').paginate(page: @page, per_page: @per_page)
      if feedbacks.empty?
        feedbacks = @user_application.feedbacks.archived.order(server_date_time: 'DESC').paginate(page: 1, per_page: @per_page)
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
