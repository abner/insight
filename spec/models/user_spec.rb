require 'rails_helper'

RSpec.describe User, :type => :model do

  let(:valid_user) { FactoryGirl.build(:user) }

  it 'requires an username' do
    new_user = FactoryGirl.build(:user, :username => '')
    expect(new_user.save).to eq(false)
    expect(new_user.errors[:username]).to include "can't be blank"
  end

  it 'requires an email' do
    new_user = FactoryGirl.build(:user, :email => '')
    expect(new_user.save).to eq(false)
    expect(new_user.errors[:email]).to include "can't be blank"
  end

  it 'does not allow to store users with same username' do
    user1 = FactoryGirl.build(:user, :username => 'same username', :email => 'user1@serpro.c.d')
    user2 = FactoryGirl.build(:user, :username => 'same username', :email => 'user2@serpro.c.d')

    expect(user1.username).to eq(user2.username)

    user1.save

    expect(user2.save).to eq(false)
    expect(user2.errors[:username]).to include 'is already taken'
  end

  it 'does not allow to store users with same email' do
    user1 = FactoryGirl.build(:user, :username => 'username 1', :email => 'sameemail@serpro.c.d')
    user2 = FactoryGirl.build(:user, :username => 'username 2', :email => 'sameemail@serpro.c.d')

    expect(user1.email).to eq(user2.email)

    user1.save

    expect(user2.save).to eq(false)
    expect(user2.errors[:email]).to include 'is already taken'
  end

end
