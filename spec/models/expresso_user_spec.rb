require 'rails_helper'

RSpec.describe ExpressoUser, :type => :model do

  it 'creates from omniauth_hash' do
    omniauth_hash =  {
      info: {
        username: 'usernane',
        tine_key: 'tine_key',
        json_key: 'json_key',
        email: 'email@email.com',
        name: 'My name',
        telephone: '555-5555',
        organization_unit: 'Company'
      }
    }
    user = ExpressoUser.from_omniauth(omniauth_hash)

    expect(ExpressoUser.count).to eq(1)
    expect(ExpressoUser.find_by(name: 'My name')).to eq(user)

  end

  it 'migrates an registered user to expresso user' do

    registered = FactoryGirl.create(:registered_user, username: 'joao')

    expect(User.count).to eq(1)

    omniauth_hash =  {
      info: {
        username: 'joao',
        tine_key: 'tine_key',
        json_key: 'json_key',
        email: 'email@email.com',
        name: 'My name',
        telephone: '555-5555',
        organization_unit: 'Company'
      }
    }

    user = ExpressoUser.from_omniauth(omniauth_hash)

    expect(User.count).to eq(1)
    expect(RegisteredUser.count).to eq(0)
    expect(ExpressoUser.find_by(username: 'joao')).to eq(user)
    expect(ExpressoUser.count).to eq(1)
  end

  it 'from_omniauth updates expresso keys' do
    omniauth_hash =  {
      info: {
        username: 'usernane',
        tine_key: 'tine_key',
        json_key: 'json_key',
        email: 'email@email.com',
        name: 'My name',
        telephone: '555-5555',
        organization_unit: 'Company'
      }
    }
    user = ExpressoUser.from_omniauth(omniauth_hash)

    expect(user.tine_key).to eq('tine_key')
    expect(user.json_key).to eq('json_key')

    omniauh_hash_updated ={
      info: {
        username: 'usernane',
        tine_key: 'tine_key_updated',
        json_key: 'json_key_update',
        email: 'email@email.com',
        name: 'My name',
        telephone: '555-5555',
        organization_unit: 'Company'
      }
    }

    user = ExpressoUser.from_omniauth(omniauh_hash_updated)

    expect(user.tine_key).to eq('tine_key_updated')
    expect(user.json_key).to eq('json_key_update')

  end

end
