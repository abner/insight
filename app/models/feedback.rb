class Feedback
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  belongs_to :project

  field :datetime, type: DateTime


end
