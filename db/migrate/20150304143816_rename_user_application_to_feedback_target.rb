class RenameUserApplicationToFeedbackTarget < Mongoid::Migration
  def self.up
    userapp_collection = Mongoid.default_session.collections.select {|x| x.name == 'user_applications'}.first
    userapp_collection.rename 'feedback_targets'
    FeedbackForm.all.each do |form|
      form.rename :user_application, :feedback_target
    end

    Feedback.all.each do |feedback|
      feedback.rename :feedback_target
    end

    User.all.each do |user|
      user.rename :feedback_target
    end

  end

  def self.down
    userapp_collection = Mongoid.default_session.collections.select {|x| x.name == 'feedback_targets'}.first
    userapp_collection.rename 'feedback_targets'
    FeedbackForm.all.each do |form|
      form.rename :user_application
    end

    Feedback.all.each do |feedback|
      feedback.rename :user_application
    end

    User.all.each do |user|
      user.rename :user_application
    end

  end
end
