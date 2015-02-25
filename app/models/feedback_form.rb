class FeedbackForm
  include Mongoid::Document

  field :name, type: String

  embeds_many :feedback_attributes

  validates_presence_of :name

  belongs_to :user_application
end
