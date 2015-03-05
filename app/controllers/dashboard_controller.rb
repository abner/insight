class DashboardController < ProtectedController

  def index
    @last_activities = []
    @feedback_targets = FeedbackTarget.all_targets_for_user(current_user)
    @last_feedbacks = Feedback.last_feedbacks_for_user(current_user)
  end
end
