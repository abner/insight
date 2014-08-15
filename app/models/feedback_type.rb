class FeedbackType
  include Mongoid::Document

  field :name, type: String

  has_many_embeded_in :feedback_attributes
  
  validates_presence_of :name

end
