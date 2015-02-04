class User
  include Mongoid::Document

  ## Database and Ldap authenticatable
  field :username, :type => String, :default => ''
  field :email,              :type => String, :default => ""


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
  validates_presence_of :email, :unless => Proc.new { |user| user.new_record? && user.is_a?(LdapUser) }

  validates :username, uniqueness: {:case_sensitive => false }
  validates :email, uniqueness: { :case_sensitive => false }

  #add_index  :users, :authentication_token, :unique => true

  scope :by_username, ->(regex){
      where(:username => /#{Regexp.escape(regex)}/i)
  }

  def id
  end
end
