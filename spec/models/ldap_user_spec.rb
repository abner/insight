require 'rails_helper'

describe LdapUser do
  let(:ldap_info) do
    {:mail => ['user@company.com']}
  end

  it 'get email from ldap info' do
    user = FactoryGirl.build(:ldap_user)
    allow(user).to receive(:ldap_get_param).with(:mail).and_return(ldap_info[:mail])
    user.save
    expect(user.email).to eq('user@company.com')
  end
end
