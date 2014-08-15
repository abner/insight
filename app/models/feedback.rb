class Feedback
  include Mongoid::Document
  #include Mongoid::Attributes::Dynamic

  belongs_to :webapp

  field :datetime, type: DateTime

  field :ip, type:String
  field :browser, type: String
  

  field :category, type: String

  field :screenshot_path, type: String



end
