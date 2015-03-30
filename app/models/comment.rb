class Comment
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :text, type: String

  belongs_to :user, index: true

  embedded_in :feedback
end
