class DashboardController < ProtectedController

  def index
    @last_activities = []
    @user_applications = UserApplication.all_apps_for_user(current_user)
    @last_feedbacks = Feedback.last_feedbacks_for_user(current_user)
  end
end
