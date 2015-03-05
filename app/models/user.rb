class User
  include Mongoid::Document


  #has_and_belongs_to_many :registered, :class_name => 'FeedbackTarget', inverse_of: :members

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

  field :blocked, :type => Boolean, :default => false

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
  has_many :feedback_targets,:class_name => 'FeedbackTarget', inverse_of: :owner

  has_and_belongs_to_many :memberships, :class_name => 'FeedbackTarget', inverse_of: :members

  validates_presence_of :username
  validates_presence_of :email, :unless => Proc.new { |user| user.new_record? && user.is_a?(LdapUser) }

  validates :username, uniqueness: {:case_sensitive => false }
  validates :email, uniqueness: { :case_sensitive => false }

  #add_index  :users, :authentication_token, :unique => true

  def my_apps
    FeedbackTarget.all_apps_for_user(self)
  end

  def owns?(feedback_target)
    self.id.eql?(feedback_target.owner.id)
  end

  def is_member?(feedback_target)
    feedback_target.member_ids.include? self.id
  end

  scope :by_username, ->(regex){
      where(:username => /#{Regexp.escape(regex.to_s)}/i)
  }
  scope :by_username_or_email, ->(regex){
     any_of({:username => /#{Regexp.escape(regex.to_s)}/i},{:email => /#{Regexp.escape(regex.to_s)}/i})
  }
end
