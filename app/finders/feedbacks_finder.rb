class FeedbacksFinder
  attr_accessor :current_user, :params

  def execute(current_user, params)
    @current_user = current_user
    @params = params

    items = init_collection
    items = by_scope(items)
    items = by_state(items)
    items = by_assignee(items)
    #items = by_labels(items)

    items = sort(items)
  end

private
  def init_collection
    if feedback_form
      if Ability.abilities.allowed?(current_user, :read_project, feedback_form)
        feedback_form.feedbacks
      else
        []
      end
    elsif feedback_target
      if Ability.abilities.allowed?(current_user, :read_project, feedback_target)
        feedback_target.feedbacks
      else
        []
      end
    else
      Feedback.feedbacks_for_user(current_user)
    end
  end

  def by_scope(items)
    case params[:scope]
      when 'archived' then
        items.archived
      when 'assigned-to-me' then
        items.where(assignee_id: current_user.id)
      when 'unassigned' then
        items.where(assignee_id: nil)
      else
        items
    end
  end

  def by_assignee(items)
    if params[:assignee_id].present?
      items = items.where(assignee_id: (params[:assignee_id] == '0' ? nil : params[:assignee_id]))
    end
    items
  end

  def by_state(items)
    if feedback_form and feedback_form.state_field
      state_field = feedback_form.state_field
      items = items.where(state_field => params[:state])
    end
    items
  end

  def sort(items)
    items.sort(params[:sort])
  end

  def feedback_target
    FeedbackTarget.where(id: params[:feedback_target_id]).first if params[:feedback_target_id].present?
  end

  def feedback_form
    feedback_target.feedback_forms.where(id: params[:feedback_form_id]).first if params[:feedback_form_id].present?
  end

end
