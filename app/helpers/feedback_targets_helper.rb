module FeedbackTargetsHelper
  def format_member_for_list(member)
    return "" if member.nil?
    return "#{member.username} (#{member.email})"
  end

end
