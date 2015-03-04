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
      user_app = valid_factory
      user_app.save!
      user_app
    end
    it 'has a default form after created' do
      expect(created.feedback_forms.count).to eq(1)
      expect(created.default_feedback_form.name).to eq(FeedbackFormTemplate.default_template_name)
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
