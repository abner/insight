class Comment
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :text, type: String

  belongs_to :user

  embedded_in :feedback
end
