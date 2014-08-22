class FeedbacksDatatable
  delegate :params, :current_user, :h, :link_to, :number_to_currency, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      recordsTotal:  all_feedbacks.count,
      recordsFiltered: feedbacks.count,
      aaData: data
    }
  end

private

  def data
    feedbacks.paginate(page: page, per_page: per_page).map do |feedback|
      [
        #link_to(feedback.id, feedback),
        feedback.view_id,
        feedback.tipo_relato,
        feedback.server_date_time.strftime("%B %e, %Y"),
        feedback.text
        #number_to_currency(product.price)
      ]
    end
  end

  def feedbacks
    @feedbacks ||= fetch_feedbacks
  end

  def all_feedbacks
    current_user.user_applications.find_by(name: params[:user_application_id]).feedbacks.order("#{sort_column} #{sort_direction}")
  end

  def fetch_feedbacks
    feedbacks = all_feedbacks
    if params[:sSearch].present?
      feedbacks = feedbacks.any_of({"text" => /#{params[:sSearch]}/i}, {:tipo_relato => /#{params[:sSearch]}/i})
    end
    feedbacks
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 15
  end

  def sort_column
    columns = %w[category server_date_time text]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
