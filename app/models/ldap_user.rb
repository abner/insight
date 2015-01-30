class LdapUser < User
  devise :ldap_authenticatable, :rememberable, :trackable

  include ZeroOidFix

  before_create :get_missing_info_from_ldap


protected

  def get_missing_info_from_ldap
    if ldap_get_param(:mail)
      self.email = ldap_get_param(:mail)
      raise "email not provided"  if self.email.nil?
    end
  end


end
