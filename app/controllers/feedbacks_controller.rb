class FeedbacksController < ProtectedController


  def index
    @user_application = current_user.user_applications.find_by(name: params[:user_application_id])
    @feedbacks = @user_application.feedbacks.order(:name => 'ASC').limit(15)
    add_breadcrumb @user_application
    add_breadcrumb 'Feedbacks', user_application_feedbacks_path(@user_application) 
    respond_to do |format|
      format.html
      format.json { render json: FeedbacksDatatable.new(view_context) }
    end
  end
end
