class FeedbackForm
  include Mongoid::Document
  include Mongoid::Slug
  # Mongoid Paranoia adds soft delete to model
  # - destroy will set deleted_at to current_time
  # - models with deleted_at defined will be ignored on default scope
  # - deleted scope is added to allow list deleted instances
  include Mongoid::Paranoia

  include Tokenable

  field :name, type: String

  embeds_many :feedback_attributes, cascade_callbacks: true, order: :position.asc
  accepts_nested_attributes_for :feedback_attributes

  belongs_to :user_application

  field :grid_columns, type: Array

  field :detail_columns, type: Array

  field :screenshot_enabled, type: Boolean, default: true
  field :review_enabled, type: Boolean, default: true

  validates_presence_of :name, :feedback_attributes, :user_application

  has_many :feedbacks, dependent: :destroy




  slug :name, history: true, scope: :user_application

  def to_s
    name
  end
end
