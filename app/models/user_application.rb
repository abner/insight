class UserApplication
  include Mongoid::Document
  include Mongoid::Slug

  include Tokenable

  field :name, type: String

  belongs_to :owner, :class_name => 'User', inverse_of: :user_applications, :foreign_key => 'owner_id'

  has_and_belongs_to_many :members, :class_name => 'User', inverse_of: :memberships

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

  # def to_param
  #    URI.escape(name)
  # end
end
