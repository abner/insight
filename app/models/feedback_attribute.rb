class FeedbackAttribute
  include Mongoid::Document

  belongs_to :type, :class_name => 'FeedbackAttributeType'

  field :name, type:String
  field :display_label, type:String
  field :custom_data, type:Hash
  field :required, type: Boolean, default: false
  field :position, type: Numeric, default: 0

  embedded_in :feedback_form

  before_create :set_position

  
  def label
    display_label.present? ?  display_label : name.humanize
  end

  validates_presence_of :name

  def set_position
    position = feedback_form.feedback_attributes.count
  end

end
