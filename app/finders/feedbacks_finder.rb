class FeedbacksFinder
  attr_accessor :current_user, :params

  include SortingHelper

  def execute(current_user, params={})
    @current_user = current_user
    @params = params



    items = init_collection
    items = by_scope(items)
    items = by_state(items)
    items = by_assignee(items)
    #items = by_labels(items)

    items = sort(items)
    items.paginate

    puts '>>>>>>>>>>>>>>>>>>>>>>>'
    puts items.inspect

    items

  end

private
  def init_collection
    if feedback_form
      if Ability.abilities.allowed?(current_user, :list_feedbacks, feedback_form)
        feedback_form.feedbacks
      else
        Feedback.where(id: -1)
      end
    elsif feedback_target
      if Ability.abilities.allowed?(current_user, :list_feedbacks, feedback_target)
        feedback_target.feedbacks
      else
        Feedback.where(id: -1)
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
      when 'unscoped' then
        items.unscoped
      else
        items
    end
  end

  def by_assignee(items)
    if params[:assignee_id].present?
      items = items.where(assignee_id: (params[:assignee_id] == '0' ? nil : params[:assignee_id]))
    end

    if params[:assigned_to_me].present?
      items = items.where(assignee_id: current_user.id)
    end
    items
  end

  def by_state(items)
    if params[:state].present?
      if feedback_form and feedback_form.state_field
        state_field = feedback_form.state_field
        items = items.where(state_field => params[:state])
      end
    end
    items
  end

  def sort(items)
    sort_args = sort_argument_from_param(params)
    items.order_by(sort_args)
  end

  def feedback_target
    if params[:feedback_target_id].present?
      if @feedback_target and @feedback_target.id.eql?(params[:feedback_target_id])
        return @feedback_target
      else
        @feedback_target = FeedbackTarget.where(id: params[:feedback_target_id]).first
      end
    end
  end

  def feedback_form
    if params[:feedback_form_id].present?
      if @feedback_form and @feedback_form.id.eql?(params[:feedback_form_id])
        return @feedback_form
      end
      @feedback_form = feedback_target.feedback_forms.where(id: params[:feedback_form_id]).first
    end
  end

end
