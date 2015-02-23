class Comment
  include Mongoid::Document

  field :text, type: String

  belongs_to :user

  embedded_in :feedback
end
