require 'rails_helper'

RSpec.describe FeedbackTarget, :type => :model do

  before :each do
    I18n.locale = :en
    DataSetup.run!
  end

  let(:valid_factory) do
    feedback_target = FactoryGirl.build(:feedback_target)
    # not necessary FactoryGirl.lint on support/factory_girl validates all factories
    # feedback_target.valid?
    feedback_target
  end

  context 'create' do
    let(:created) do
      target = valid_factory
      target.save!
      target
    end
    it 'has a default form after created' do
      expect(created.feedback_forms.count).to eq(1)
      expect(created.default_feedback_form.name).to eq(FeedbackFormTemplate.default_template_name)
    end
  end

  describe '#include_members' do
    let(:target) do
      target = valid_factory
      target.save!
      target
    end

    let(:new_user) do
      FactoryGirl.create(:registered_user)
    end

    it 'add members for feedback_target' do
      expect(target.members).to be_empty
      target.include_members(new_user.id.to_s)
      expect(target.members.count).to eq(1)
    end
  end

  describe '#remove_members' do
    let!(:member) do
      FactoryGirl.create(:registered_user)
    end

    let!(:target_with_member) do
      target = valid_factory
      target.save!
      target.members << member
      target.save!
      target
    end

    it 'remove member for feedback_target' do
      expect(target_with_member.members.count).to eq(1)
      target_with_member.remove_member member.id.to_s
      expect(target_with_member.members.count).to eq(0)
    end
  end

  describe '#members_usernames' do
    let!(:member) do
      FactoryGirl.create(:registered_user)
    end

    let!(:target_with_member) do
      target = valid_factory
      target.save!
      target.members << member
      target.save!
      target
    end
    it 'maps names of members to an array' do
      expect(target_with_member.members_usernames).to eq([member.username])
    end
  end

  describe '#list_members_candidates' do
    let!(:member) do
      FactoryGirl.create(:registered_user, username: 'member')
    end

    let!(:user1) do
      FactoryGirl.create(:registered_user, username: 'user1')
    end

    let!(:user2) do
      FactoryGirl.create(:registered_user, username: 'user2')
    end

    let!(:target_with_member) do
      target = valid_factory
      target.save!
      target.members << member
      target.save!
      target
    end
    it 'filter users which would be added as member' do
      expect(target_with_member.list_members_candidates('user1')).to include user1
      expect(target_with_member.list_members_candidates('user1')).not_to include user2
      expect(target_with_member.list_members_candidates('user')).to include user1, user2
    end
    it 'not return users which are members already' do
      expect(target_with_member.list_members_candidates('member')).to be_empty
    end
  end

  describe 'all_targets_for_user' do
    let!(:user) do
      FactoryGirl.create(:registered_user, username: 'member')
    end

    let!(:target_with_member) do
      target = valid_factory
      target.save!
      target.members << user
      target.save!
      target
    end

    let!(:target_owned) do
      feedback_target = FactoryGirl.create(:feedback_target, :owner => user)
    end

    it 'returns targets user owns or is member of' do
      expect(FeedbackTarget.all_targets_for_user(user)).to include target_with_member, target_owned
    end
  end

  describe 'before create' do
    let('target') { FactoryGirl.build(:feedback_target) }
    it 'prevent cretion if default form generation fails' do
      allow(target).to receive(:set_default_form!).and_raise(RuntimeError, 'Invalid form creation')
      expect { target.save!(name: 'New', owner: FactoryGirl.create(:registered_user)) }.to raise_error(RuntimeError, /Error creating default form for application/)
    end
  end

  #let!(:token_format) { /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i }

  #it { should validate_uniqueness_of(:name).case_insensitive }
  #it { should validate_uniqueness_of(:token).case_insensitive }

  #it { should belong_to_related(:owner) }

  it 'raise error if no owner is provided on creation' do
    expect{ FeedbackTarget.create!(:name =>'App1') }.to raise_error(Mongoid::Errors::Validations)
  end

  it 'needs to have a name and an owner to be valid' do
    #name
    expect(valid_factory.name.strip).not_to be_blank

    #owner
    expect(valid_factory.owner).not_to be(nil)
  end

  it 'receives a token number after creation' do
    feedback_target = valid_factory
    expect(feedback_target.authentication_token).to be_blank
    feedback_target.save
    expect(feedback_target.authentication_token).not_to be_blank
    #expect(feedback_target.token).to match(token_format)
  end

  it 'not allow store feedback_targets with same name' do
    owner = FactoryGirl.create(:registered_user)
    feedback_target1 = FactoryGirl.build(:feedback_target, :owner => owner)
    feedback_target2 = FactoryGirl.build(:feedback_target, :owner => owner)

    feedback_target2.name = feedback_target1.name

    expect(feedback_target1.name).to eq(feedback_target2.name)

    expect(feedback_target1.save).to be(true)
    expect(feedback_target2.save).to be(false)

    expect(feedback_target2.errors[:name].size).to be  > 0
    expect(feedback_target2.errors[:name]).to include("is already taken")

  end

  it 'not allow store feedback_targets with same token' do
    owner = FactoryGirl.create(:registered_user)
    feedback_target1 = FactoryGirl.build(:feedback_target, :owner => owner)
    feedback_target2 = FactoryGirl.build(:feedback_target, :name => 'another_feedback_target', :owner => owner)

    expect(feedback_target1.save).to be(true)
    expect(feedback_target2.save).to be(true)

    feedback_target2.authentication_token = feedback_target1.authentication_token

    expect(feedback_target2.save).to be(false)
    expect(feedback_target2.errors[:authentication_token]).to include('is already taken')
  end

end
