require 'rails_helper'

RSpec.describe Project, :type => :model do

  let(:valid_factory) do
    project = FactoryGirl.build(:project)
    # not necessary FactoryGirl.lint on support/factory_girl validates all factories
    # project.valid?
    project
  end

  let!(:token_format) { /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i }

  #it { should validate_uniqueness_of(:name).case_insensitive }
  #it { should validate_uniqueness_of(:token).case_insensitive }

  #it { should belong_to_related(:owner) }

  it 'raise error if no owner is provided on creation' do
    expect{ Project.create!(:name =>'App1') }.to raise_error(Mongoid::Errors::Validations)
  end

  it 'needs to have a name and an owner to be valid' do
    #name
    expect(valid_factory.name.strip).not_to be_blank

    #owner
    expect(valid_factory.owner).not_to be(nil)
  end

  it 'receives a token number after creation' do
    project = valid_factory
    expect(project.token).to be_blank
    project.save
    expect(project.token).not_to be_blank
    expect(project.token).to match(token_format)
  end

  it 'not allow store projects with same name' do
    owner = FactoryGirl.create(:user)
    project1 = FactoryGirl.build(:project, :owner => owner)
    project2 = FactoryGirl.build(:project, :owner => owner)

    project2.name = project1.name

    expect(project1.name).to eq(project2.name)

    expect(project1.save).to be(true)
    expect(project2.save).to be(false)

    expect(project2.errors[:name].size).to be  > 0
    expect(project2.errors[:name]).to include("is already taken")

  end

  it 'not allow store projects with same token' do
    owner = FactoryGirl.create(:user)
    project1 = FactoryGirl.build(:project, :owner => owner)
    project2 = FactoryGirl.build(:project, :name => 'another_project', :owner => owner)

    expect(project1.save).to be(true)
    expect(project2.save).to be(true)

    project2.token = project1.token

    expect(project2.save).to be(false)
    expect(project2.errors[:token]).to include('is already taken')
  end

end
