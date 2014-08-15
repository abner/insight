class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :ldap_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable,
  :authentication_keys => [:username]#, :validatable

  ## Database authenticatable
  field :username, :type => String, :default => ''
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String
  has_many :user_applications

  validates_presence_of :username
  validates_presence_of :email, :unless => Proc.new { |user| user.new_record? }

  validates :username, uniqueness: {:case_sensitive => false }
  validates :email, uniqueness: { :case_sensitive => false }

  before_create :get_missing_info_from_ldap

  #add_index  :users, :authentication_token, :unique => true

  class << self
    def serialize_into_session(record)
      [record.id.to_s, record.authenticatable_salt]
    end
  end

  protected

  def get_missing_info_from_ldap
    attributes[:email] = ldap_get_param(:mail)
    raise "email not provided" if attributes[:email].nil?
  end

end
