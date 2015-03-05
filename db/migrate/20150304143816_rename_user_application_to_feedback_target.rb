class RenameUserApplicationToFeedbackTarget < Mongoid::Migration
  def self.up
    userapp_collection = Mongoid.default_session.collections.select {|x| x.name == 'user_applications'}.first

    userapp_collection.rename 'feedback_targets' if userapp_collection

    FeedbackForm.all.each do |form|
      form.rename :user_application => :feedback_target
      form.rename :user_application_id => :feedback_target_id
    end

    Feedback.all.each do |feedback|
      feedback.rename :user_application => :feedback_target
      feedback.rename :user_application_id => :feedback_target_id
    end

    User.all.each do |user|
      user.rename :user_application => :feedback_target
      user.rename :user_application_id => :feedback_target_id
    end

  end

  def self.down
    userapp_collection = Mongoid.default_session.collections.select {|x| x.name == 'feedback_targets'}.first
    userapp_collection.rename 'feedback_targets'
    FeedbackForm.all.each do |form|
      form.rename :feedback_target => :user_application
      form.rename :feedback_target_id => :user_application_id
    end

    Feedback.all.each do |feedback|
      feedback.rename :feedback_target => :user_application
      feedback.rename :feedback_target_id => :user_application_id
    end

    User.all.each do |user|
      user.rename :feedback_target => :user_application
      user.rename :feedback_target_id => :user_application_id
    end

  end
end
