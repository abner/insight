class FeedbackAttribute
  include Mongoid::Document

  belongs_to :type, :class_name => 'FeedbackAttributeType'

  field :name, type:String
  field :display_label, type:String
  field :custom_data, type:Hash
  field :required, type: Boolean, default: false

  embedded_in :feedback_form
  
end
