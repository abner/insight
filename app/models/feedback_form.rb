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

  embeds_many :feedback_attributes,
   cascade_callbacks: true,
   order: :position.asc,
   before_add: :set_position

  accepts_nested_attributes_for :feedback_attributes, :reject_if => :all_blank, :allow_destroy => true

  belongs_to :feedback_target

  field :grid_columns, type: Array

  field :detail_columns, type: Array

  field :screenshot_enabled, type: Boolean, default: true
  field :review_enabled, type: Boolean, default: true

  validates_presence_of :name, :feedback_attributes, :feedback_target

  has_many :feedbacks, dependent: :destroy




  slug :name, history: true, scope: :feedback_target

protected
  def set_position(attribute)
    if attribute and 0.eql?(attribute.position)
      attribute.position = self.feedback_attributes.count
    end
  end



end
