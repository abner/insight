class FeedbacksController < ProtectedController


  def index
    @user_application = current_user.my_apps.find(params[:user_application_id])

    #@feedbacks = @user_application.feedbacks.order(:name => 'ASC').limit(15)

    page = params[:page] || 1
    per_page = params[:per_page] || Feedback.per_page


    @feedbacks = @user_application.feedbacks.order(server_date_time: 'DESC').paginate(page: page, per_page: per_page)

    add_breadcrumb @user_application
    add_breadcrumb 'Feedbacks', user_application_feedbacks_path(@user_application)
    respond_to do |format|
      format.html
      format.json { render json: FeedbacksDatatable.new(view_context) }
    end
  end

  def archive
    @feedback = nil
    respond_to do |format|
      format.html
      format.js do
        begin
          @feedback = feedback_from_params
          @feedback.archive!
          render json: respond_success_json(:object => @feedback), :content_type => 'application/javascript'
        rescue Exception => e
          render json: respond_error_json(:message => e.message ,:object => @feedback), :content_type => 'application/javascript'
        end
      end
    end
  end

protected
  def feedback_from_params
    @feedback ||= user_application.feedbacks.find params[:id]
  end
  def user_application
    @user_application ||= UserApplication.all_apps_for_user(current_user).find(user_applciation_id_param)
  end

  def user_applciation_id_param
    params[:user_application_id]
  end
end
