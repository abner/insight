class FeedbackFormTemplate
  include Mongoid::Document

  field :name, type: String

  embeds_many :feedback_attributes,
    :class_name => 'FeedbackAttributeTemplate', before_add: :set_position

  validates_presence_of :name

  embeds_many :state_transitions, cascade_callbacks: true
  accepts_nested_attributes_for :state_transitions, :reject_if => :all_blank, :allow_destroy => true

  field :initial_state, type: Symbol
  field :state_field, type: String
  field :state_field_label, type: String

  field :grid_columns, type: Array
  field :detail_columns, type: Array
  field :description_columns, type: Array
  field :screenshot_enabled, type: Boolean, default: true
  field :review_enabled, type: Boolean, default: true
  field :description_field_name, type: String

  def self.default_template
    where(name: default_template_name).first
  end

  def self.default_template_name
    'Relato ou Sugestão'
  end

  def attributes_template
    self.attributes.except('_id')
  end
protected
  def set_position(feedback_attribute)
    feedback_attribute.position = feedback_attributes.count
  end
end
