class UserApplication
  include Mongoid::Document
  include Tokenable

  field :name, type: String

  belongs_to :owner, :class_name => 'User'

  validates :name, uniqueness: { :case_sensitive => false }

  validates_presence_of :owner

  validates_presence_of :name

  has_many :feedbacks
end
