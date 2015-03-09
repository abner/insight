class FeedbackTarget
  include Mongoid::Document
  include Mongoid::Slug

  # Mongoid Paranoia adds soft delete to model
  # - destroy will set deleted_at to current_time
  # - models with deleted_at defined will be ignored on default scope
  # - deleted scope is added to allow list deleted instances
  include Mongoid::Paranoia

  include Tokenable

  # callbacks
  after_create :create_default_form!

  # fields
  field :name, type: String

  field :default_feedback_form_id, type: String

  # slug definition
  slug :name, history: true, scope: :owner

  # validations
  validates :name, uniqueness: { :case_sensitive => false, conditions: -> { where(deleted_at: nil) } }
  validates_presence_of :owner
  validates_presence_of :name

  # associations
  belongs_to :owner, class_name: 'User', inverse_of: :feedback_targets, foreign_key: 'owner_id'
  has_and_belongs_to_many :members, class_name: 'User', inverse_of: :memberships
  has_many :feedback_forms,
            class_name: 'FeedbackForm',
            inverse_of: :feedback_target,
            foreign_key: 'feedback_target_id',
            dependent: :destroy

  has_many :feedbacks #, dependent: :destroy
  #belongs_to :default_feedback_form, class_name: 'FeedbackForm'
  #has_many :members, :class_name => 'User'

  # scopes
  scope :all_targets_for_user, ->(user){
      any_of({:owner => user}, {:member_ids.in => [user.id]})
  }

  def include_members member_ids_str
    return if member_ids_str.empty?
    arr_ids = member_ids_str.split(',')
    arr_ids.each do |id|
      if self.members.where(id: id).empty?
        self.members << User.find(id)
      end
    end
  end

  def remove_member member_id_str
    return false if member_id_str.empty?
    user = self.members.where(id: member_id_str).first
    return false if user.nil? #false se não encontrou membro
    return self.members.delete(user).present? #true se o usuario foi removido como membro
  end

  def members_usernames
    members_names = members.empty? ? []  : members.map {|m| m.username}
  end

  def list_members_candidates(username_filter)
    already_members_filter = members_usernames + [owner.username]
    User.by_username_or_email(username_filter) & User.where(:username.nin => already_members_filter)
  end

  def default_feedback_form
    self.feedback_forms.where(_id: self.default_feedback_form_id).first
  end

  def set_default_form! feedback_form
    self.write_attribute(:default_feedback_form_id, feedback_form.id.to_s)
    self.save!
  end

protected
  def create_default_form!
    form = nil
    begin
      #raise Exception.new "ABBBB"
      #creates a form using FeedbackFormTemplate.default_template as base
      form_attributes = FeedbackFormTemplate.default_template.attributes_template

      form_attributes.merge!(:feedback_target => self)

      form = FeedbackForm.create!(form_attributes)

      #set as default form for this feedback_target
      set_default_form! form
      save!
    rescue Exception => e
      destroy
      msg = e.message
      msg = "#{msg} #{form.errors}" if form
      raise "Error creating default form for application #{msg}"
    end
  end

end
