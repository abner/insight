class UserApplication
  include Mongoid::Document
  include Mongoid::Slug

  include Tokenable

  after_create :create_default_form!


  field :name, type: String

  belongs_to :owner, :class_name => 'User', inverse_of: :user_applications, :foreign_key => 'owner_id'

  has_and_belongs_to_many :members, :class_name => 'User', inverse_of: :memberships

  has_many :feedback_forms, :class_name => 'FeedbackForm'

  field :default_feedback_form, type: String

  #has_many :members, :class_name => 'User'

  slug :name, history: true, scope: :owner

  validates :name, uniqueness: { :case_sensitive => false }

  validates_presence_of :owner

  validates_presence_of :name

  has_many :feedbacks

  scope :all_apps_for_user, ->(user){
      any_of({:owner => user}, {:member_ids.in => [user.id]})
  }

  def to_s
    name
  end

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

  def members_user_names
    members_names = members.empty? ? []  : members.map {|m| m.username}
  end

  def list_members_candidates(username_filter)
    already_members_filter = members_user_names + [owner.username]
    User.by_username_or_email(username_filter) & User.where(:username.nin => already_members_filter)
  end

  def default_form
    feedback_forms.where(:name => default_feedback_name).first
  end
#protected
  def set_default_form feedback_form
    write_attribute(:default_feedback_form, feedback_form.name)
  end

  def create_default_form!
    begin
      #creates a form using FeedbackFormTemplate.default_template as base
      form_attributes = FeedbackFormTemplate.default_template.attributes_template
      form = feedback_forms.create! form_attributes
      #set as default form for this user_application
      set_default_form form
    rescue
      self.destroy
      raise 'Error creating application'
    end
  end

end
