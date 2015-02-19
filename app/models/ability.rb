class Ability
  class << self
    def allowed(user, subject)
      return [] if user.nil?
      return [] unless user.kind_of?(User)
      return [] if user.blocked?

      case subject.class.name
      when "UserApplication" then user_application_abilities(user, subject)
      when "Feedback" then feedback_abilities(user, subject)
      when "Comment" then comment_abilities(user, subject)
      else []
      end
    end

    def user_application_abilities(user, user_application)
      rules = []

      if user.is_member?(user_application) or user.owns?(user_application)
        rules << :read_user_application
      end

      if(user.owns?(user_application))
        rules << :write_user_application
        rules << :remove_user_application
        rules << :admin_team_members
      end

      rules
    end

    def feedback_abilities(user, feedback)
      rules = []
      if user.is_member?(feedback.user_application) or user.owns?(feedback.user_application)
        rules << :read_feedback
        rules << :change_feedback_status
        rules << :comment_on_feedback
        rules << :archive_feedback
      end
      rules
    end

    def comment_abilities(user, comment)
      rules = []

      if user.is_member?(comment.feedback.user_application)
        rules << :read_comment
      end

      if user.owns?(comment)
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
