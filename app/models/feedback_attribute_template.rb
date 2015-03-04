class FeedbackAttributeTemplate
  include Mongoid::Document

  field :name, type:String
  field :display_label, type:String


  belongs_to :type, :class_name => 'FeedbackAttributeType'

  embedded_in :feedback_form_template

  field :custom_data, type:Hash
  field :required, type: Boolean, default: false
  field :position, type: Numeric

  before_create :set_position


  def self.template_for name
    model = where(name: name).first
    raise 'not found'  unless model
    return model.attributes.except('_id')
  end

protected
  def set_position
    self.position = self.feedback_form_template.feedback_attributes.count
  end
end
