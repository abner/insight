module Tokenable
  extend ActiveSupport::Concern

  included do
    field :authentication_token, type: String

    validates :authentication_token, uniqueness: { :case_sensitive => false }

    before_validation :generate_token, :on => :create
  end

  protected

  def generate_token
    self.authentication_token = loop do
      #random_token = SecureRandom.urlsafe_base64(nil, false)
      #random_token = SecureRandom.uuid
      random_token = SecureRandom.urlsafe_base64

      break random_token unless self.class.where(authentication_token: random_token).exists?
    end
  end
end
