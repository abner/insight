require 'rails_helper'

describe UserApplicationsController, :type => :controller do

  login_user

  it "should have a current_user" do
    # note the fact that I removed the "validate_session" parameter if this was a scaffold-generated controller
    expect(subject.current_user).not_to be_nil
  end

  describe "GET index" do
    it 'assigns @user_applications' do
      user_application = FactoryGirl.create(:user_application, :owner => subject.current_user)
      get :index
      expect(response.status).to eq(200)
      expect(assigns(:user_applications)).to eq([user_application])
    end
  end

  describe "GET new" do

  end

  describe "POST create" do
    it 'creates a new user_application' do
    end

    it 'does not create user_application if name is missing' do
    end

    it 're-show edit if name is missing' do
    end

    it 'redirects to #index after creates successfully' do
    end
  end

  describe "DELETE destroy" do
    it 'destroy an user_application' do
    end

    it 'redirects to #index after destroy' do
    end
  end

  describe 'GET new' do
    it 'render page with empty form' do
    end
  end

end
