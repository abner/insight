require 'rails_helper'

RSpec.describe UserApplication, :type => :model do

  before :each do
    I18n.locale = :en
    DataSetup.run!
  end

  let(:valid_factory) do
    user_application = FactoryGirl.build(:user_application)
    # not necessary FactoryGirl.lint on support/factory_girl validates all factories
    # user_application.valid?
    user_application
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
    expect{ UserApplication.create!(:name =>'App1') }.to raise_error(Mongoid::Errors::Validations)
  end

  it 'needs to have a name and an owner to be valid' do
    #name
    expect(valid_factory.name.strip).not_to be_blank

    #owner
    expect(valid_factory.owner).not_to be(nil)
  end

  it 'receives a token number after creation' do
    user_application = valid_factory
    expect(user_application.authentication_token).to be_blank
    user_application.save
    expect(user_application.authentication_token).not_to be_blank
    #expect(user_application.token).to match(token_format)
  end

  it 'not allow store user_applications with same name' do
    owner = FactoryGirl.create(:registered_user)
    user_application1 = FactoryGirl.build(:user_application, :owner => owner)
    user_application2 = FactoryGirl.build(:user_application, :owner => owner)

    user_application2.name = user_application1.name

    expect(user_application1.name).to eq(user_application2.name)

    expect(user_application1.save).to be(true)
    expect(user_application2.save).to be(false)

    expect(user_application2.errors[:name].size).to be  > 0
    expect(user_application2.errors[:name]).to include("is already taken")

  end

  it 'not allow store user_applications with same token' do
    owner = FactoryGirl.create(:registered_user)
    user_application1 = FactoryGirl.build(:user_application, :owner => owner)
    user_application2 = FactoryGirl.build(:user_application, :name => 'another_user_application', :owner => owner)

    expect(user_application1.save).to be(true)
    expect(user_application2.save).to be(true)

    user_application2.authentication_token = user_application1.authentication_token

    expect(user_application2.save).to be(false)
    expect(user_application2.errors[:authentication_token]).to include('is already taken')
  end

end
