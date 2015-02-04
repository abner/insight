class RegisteredUser < User

  devise :database_authenticatable, :recoverable,
        :registerable, :rememberable, :trackable,
        :authentication_keys => [:username]

  include ZeroOidFix

  field :encrypted_password, :type => String, :default => ""


  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

end
