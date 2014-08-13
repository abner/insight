class Project
  include Mongoid::Document
  include Tokenable

  field :name, type: String
  field :token, type: String
  belongs_to :user
end
