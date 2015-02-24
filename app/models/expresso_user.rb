class ExpressoUser < User
  devise :rememberable, :trackable,
    :authentication_keys => [:username]

  field :name, :type => String
  field :telephone, :type => String, default: ''
  field :organization_unit, :type => String, default: ''
  field :tine_key, :type => String, default: ''
  field :json_key, :type => String, default: ''

  validates_presence_of :name

  include ZeroOidFix


  def self.from_omniauth(omniauth_hash)
    #detects if there is a registered user and return it converted as an expresso user
    registered_user = RegisteredUser.where(:username => omniauth_hash[:info][:username]).first

    #convert user o expresso user
    return migrate_to_expresso_user(registered_user, omniauth_hash) if registered_user

    #otherwise try to find an Expresso User already on database
    user = ExpressoUser.where(username: omniauth_hash[:info][:username]).first

    if user
      #updates expresso json rpc keys on database
      user.tine_key = omniauth_hash[:info][:tine_key]
      user.json_key = omniauth_hash[:info][:json_key]
      user.save!
    else
      #create a new expresso user if none was found
      user = ExpressoUser.create do
        user.username = omniauth_hash[:info][:username]
        user.email = omniauth_hash[:info][:email]
        user.name = omniauth_hash[:info][:name]
        user.telephone = omniauth_hash[:info][:telephone]
        user.organization_unit = omniauth_hash[:info][:organization_unit]
        user.tine_key = omniauth_hash[:info][:tine_key]
        user.json_key = omniauth_hash[:info][:json_key]
        user.save!
      end
    end
    user
  end

private
  def self.migrate_to_expresso_user(registered_user, omniauth_hash)
    registered_user._type = 'ExpressoUser'
    registered_user.save!
    expresso_user = ExpressoUser.where(username: omniauth_hash[:info][:username]).first
    expresso_user.email = omniauth_hash[:info][:email]
    expresso_user.name = omniauth_hash[:info][:name]
    expresso_user.telephone = omniauth_hash[:info][:telephone]
    expresso_user.organization_unit = omniauth_hash[:info][:organization_unit]
    expresso_user.tine_key = omniauth_hash[:info][:tine_key]
    expresso_user.json_key = omniauth_hash[:info][:json_key]
    expresso_user.save!
    expresso_user
  end
end
