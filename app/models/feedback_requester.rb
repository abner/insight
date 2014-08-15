class FeedbackRequeter
  include Mongoid::Document

  field :user_id, type: String
  field :url, type: String
  field :browser, type: String
  field :local_date_time, type: String
  field :operational_system, type: String

end
