require 'rails_helper'

RSpec.describe User, :type => :model do

  before :each do
    I18n.locale = :en
  end

  let(:valid_user) { FactoryGirl.build(:registered_user) }

  it 'requires an username' do
    new_user = FactoryGirl.build(:registered_user, :username => '')
    expect(new_user.save).to eq(false)
    expect(new_user.errors[:username]).to include "can't be blank"
  end

  it 'requires an email' do
    user = FactoryGirl.build(:registered_user, :email => '')
    allow(user).to receive(:new_record?).and_return(false)
    expect(user.save).to eq(false)
    expect(user.errors[:email]).to include "can't be blank"
  end

  it 'does not allow to store users with same username' do
    user1 = FactoryGirl.build(:registered_user, :username => 'same username', :email => 'user1@serpro.c.d')
    user2 = FactoryGirl.build(:registered_user, :username => 'same username', :email => 'user2@serpro.c.d')

    expect(user1.username).to eq(user2.username)

    user1.save

    expect(user2.save).to eq(false)
    expect(user2.errors[:username]).to include 'is already taken'
  end

  it 'does not allow to store users with same email' do
    user1 = FactoryGirl.build(:registered_user, :username => 'username 1', :email => 'sameemail@serpro.c.d')
    user2 = FactoryGirl.build(:registered_user, :username => 'username 2', :email => 'sameemail@serpro.c.d')

    expect(user1.email).to eq(user2.email)

    user1.save

    expect(user2.save).to eq(false)
    expect(user2.errors[:email]).to include 'is already taken'
  end

  it 'finds by username' do
    FactoryGirl.create(:registered_user, :username => 'joao', :email => 'maria@serpro.c.d')
    FactoryGirl.create(:registered_user, :username => 'maria', :email => 'joao@serpro.c.d')

    user_found = User.by_username('jo').first
    expect(user_found.username).to eq('joao')

    user_found = User.by_username('ma').first
    expect(user_found.username).to eq('maria')
  end

  it 'not find by username' do
    FactoryGirl.create(:registered_user, :username => 'joao', :email => 'maria@serpro.c.d')
    expect(User.by_username('PESSOA').to_a).to be_empty
  end

  it 'owns feedback_target' do
    user = FactoryGirl.create(:registered_user, :username => 'joao', :email => 'maria@serpro.c.d')
    feedback_target = FactoryGirl.create(:feedback_target, :owner => user)
    expect(user.owns?(feedback_target)).to eq(true)
  end

  it 'is member of feedback_targets' do
    user = FactoryGirl.create(:registered_user, :username => 'joao', :email => 'maria@serpro.c.d')
    feedback_target = FactoryGirl.create(:feedback_target)
    feedback_target.members << user
    expect(user.is_member?(feedback_target)).to eq(true)
  end

  it 'has my_targets collection which lists feedback_targets he owns and is member of' do
    user = FactoryGirl.create(:registered_user, :username => 'joao', :email => 'maria@serpro.c.d')
    feedback_target_member = FactoryGirl.create(:feedback_target)
    feedback_target_member.members << user

    feedback_target_owned = FactoryGirl.create(:feedback_target, :owner => user)

    expect(user.my_targets).to include(feedback_target_member)
    expect(user.my_targets).to include(feedback_target_owned)
  end

  it 'is located by username or email' do
    user = FactoryGirl.create(:registered_user, :username => 'joao', :email => 'joaomaria@serpro.c.d')
    expect(User.by_username_or_email('joao').first).to eq(user)
    expect(User.by_username_or_email('maria').first).to eq(user)
    expect(User.by_username_or_email('joaomaria').first).to eq(user)
    expect(User.by_username_or_email('ze').first).to be_nil
  end

  it 'is located by username' do
    user = FactoryGirl.create(:registered_user, :username => 'joao', :email => 'joaomaria@serpro.c.d')
    expect(User.by_username('joao').first).to eq(user)
    expect(User.by_username('jo').first).to eq(user)

    expect(User.by_username('ze').first).to be_nil
    expect(User.by_username('maria').first).to be_nil
    expect(User.by_username('joaomaria').first).to be_nil
  end

end
