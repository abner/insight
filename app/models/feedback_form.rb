class FeedbackForm
  include Mongoid::Document
  include Mongoid::Slug

  field :name, type: String

  embeds_many :feedback_attributes

  belongs_to :user_application

  field :grid_columns, type: Array

  field :detail_columns, type: Array

  field :screenshot_enabled, type: Boolean, default: true
  field :review_enabled, type: Boolean, default: true

  validates_presence_of :name, :feedback_attributes, :user_application

  has_many :feedbacks


  slug :name, history: true, scope: :user_application

  def to_s
    name
  end
end
