class FeedbacksController < ProtectedController


  def index
    @user_application = current_user.user_applications.find(params[:user_application_id])

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
end
