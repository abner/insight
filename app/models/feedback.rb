class Feedback
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  belongs_to :user_application

  field :server_date_time, type: DateTime

  field :screenshot_path

  field :text, type: String

  field :category, type: String

  field :screenshot_path, type: String

  embeds_one :feedback_requester

  validates_presence_of :text

  before_save :fill_automatic_fields

  def view_id
    id.to_s
  end


  protected
  def fill_automatic_fields
    #check app region information
    self.server_date_time = DateTime.now
  end
end
