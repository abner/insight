class FeedbackAttribute
  include Mongoid::Document

  field :name, type:String
  field :display_label, type:String
  field :type, type: FeedbackAttributeType
end
