class TransferFeedbacksFromUserApplicationsToDefaultForm < Mongoid::Migration
  def self.check_class
    begin
      UserApplication
    rescue
      return false
    end
    true
  end
  def self.up
    if check_class
      UserApplication.all.each do |app|
        if(app.default_feedback_form.feedbacks.empty? && app.feedbacks.count > 0)
          app.feedbacks.each do |feedback|
            feedback.update_attribute(:feedback_form, app.default_feedback_form) if feedback.feedback_form.nil?
          end
        end
      end
    end
  end

  def self.down
  end
end
