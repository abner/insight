class FeedbackFormTemplate
  include Mongoid::Document

  field :name, type: String

  embeds_many :feedback_attributes, :class_name => 'FeedbackAttributeTemplate'

  validates_presence_of :name

end
