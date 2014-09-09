class UserApplication
  include Mongoid::Document
  include Mongoid::Slug

  include Tokenable

  field :name, type: String

  belongs_to :owner, :class_name => 'User'

  slug :name, history: true, scope: :owner

  validates :name, uniqueness: { :case_sensitive => false }

  validates_presence_of :owner

  validates_presence_of :name

  has_many :feedbacks

  def to_s
    name
  end

  # def to_param
  #    URI.escape(name)
  # end
end
