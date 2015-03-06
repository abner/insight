class FeedbackFormTemplate
  include Mongoid::Document

  field :name, type: String

  embeds_many :feedback_attributes,
    :class_name => 'FeedbackAttributeTemplate', before_add: :set_position

  validates_presence_of :name

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
