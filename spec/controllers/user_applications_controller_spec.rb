require 'rails_helper'

describe UserApplicationsController, :type => :controller do

  login_user

  controller do
    def define_locale
      I18n.locale = :en
    end
  end

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
    it 'render new form' do
      get :new
      expect(response.status).to eq(200)
      expect(response).to render_template(:new)
    end
  end

  describe "POST create" do
    it 'creates a new user_application' do
      expect(subject.current_user.user_applications.count).to eq(0)
      post :create, :user_application => { :name => 'new app' }
      expect(subject.current_user.user_applications.count).to eq(1)
    end

    it 'does not create user_application if name is blank' do
      expect(subject.current_user.user_applications.count).to eq(0)
      post :create, :user_application => { :name => '' }
      expect(response.status).to eq(200)
      expect(assigns(:user_application).errors[:name]).to include("can't be blank")
    end

    it 're-show new if name is missing' do
      expect(subject.current_user.user_applications.count).to eq(0)
      post :create, :user_application => { :name => '' }
      expect(response.status).to eq(200)
      expect(response).to render_template(:new)
    end
    it 'redirects to #index after creates successfully' do
      expect(subject.current_user.user_applications.count).to eq(0)
      post :create, :user_application => { :name => 'new app' }
      expect(response.status).to eq(302)
      expect(response).to redirect_to(user_applications_path)
    end
  end

  describe "DELETE destroy" do
    it 'destroy an user_application' do
      user_app = subject.current_user.user_applications.create(name: "new app")
      expect(subject.current_user.user_applications.count).to eq(1)
      delete :destroy, :id => user_app.to_param
      expect(subject.current_user.user_applications.count).to eq(0)
    end

    it 'redirects to #index after destroy' do
      user_app = subject.current_user.user_applications.create(name: "new app")
      expect(subject.current_user.user_applications.count).to eq(1)
      delete :destroy, :id => user_app.to_param
      expect(response.status).to eq(302)
      expect(response.status).to redirect_to(user_applications_path)
    end
  end

  describe 'GET show' do
    it 'render page with application info' do

    end
  end

end
