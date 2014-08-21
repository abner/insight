class FeedbacksController < ProtectedController

  def index
    @user_application = current_user.user_applications.find_by(name: params[:user_application_id])
    @feedbacks = @user_application.feedbacks.order(:name => 'ASC').limit(30)

    respond_to do |format|
      format.html
      format.json { render json: FeedbacksDatatable.new(view_context) }
    end
  end
end
