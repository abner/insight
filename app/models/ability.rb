class Ability
  class << self
    def allowed(user, subject)
      return [] if user.nil?
      return [] unless user.kind_of?(User)
      return [] if user.blocked?

      case subject.class.name
      when "FeedbackTarget" then feedback_target_abilities(user, subject)
      when "Feedback" then feedback_abilities(user, subject)
      when "Comment" then comment_abilities(user, subject)
      when "FeedbackForm" then feedback_form_abilities(user, subject)
      else []
      end
    end

    def feedback_target_abilities(user, feedback_target)
      rules = []

      if user.is_member?(feedback_target) or user.owns?(feedback_target)
        rules << :read_feedback_target
        rules << :list_feedback_forms
        rules << :create_feedback_form
      end


      if(user.owns?(feedback_target))
        rules << :write_feedback_target
        rules << :remove_feedback_target
        rules << :admin_team_members
      end

      rules
    end

    def feedback_form_abilities(user, feedback_form)
      rules = []
      if user.is_member?(feedback_form.feedback_target) or user.owns?(feedback_form.feedback_target)
        rules << :read_feedback_form
        rules << :write_feedback_form
      end
      rules
    end

    def feedback_abilities(user, feedback)
      rules = []
      if user.is_member?(feedback.feedback_target) or user.owns?(feedback.feedback_target)
        rules << :read_feedback
        rules << :change_feedback_status
        rules << :comment_on_feedback
        rules << :archive_feedback
        rules << :unarchive_feedback
      end
      rules
    end

    def comment_abilities(user, comment)
      rules = []

      if user.is_member?(comment.feedback.feedback_target)
        rules << :read_comment
      end

      if user.eql?(comment.user)
        rules << :remove_comment
        rules << :write_comment
      end

      rules
    end



    def abilities
      @abilities ||= begin
                       abilities = Six.new
                       abilities << self
                       abilities
                     end
    end
  end
end
