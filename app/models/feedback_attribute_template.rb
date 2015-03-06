class FeedbackAttributeTemplate
  include Mongoid::Document

  field :name, type:String
  field :display_label, type:String


  belongs_to :type, :class_name => 'FeedbackAttributeType'

  embedded_in :feedback_form_template

  field :custom_data, type:Hash
  field :required, type: Boolean, default: false
  field :position, type: Numeric

end
