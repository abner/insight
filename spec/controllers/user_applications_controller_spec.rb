require 'rails_helper'

describe FeedbackTargetsController, :type => :controller do

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
    it 'assigns @feedback_targets' do
      feedback_target = FactoryGirl.create(:feedback_target, :owner => subject.current_user)
      get :index
      expect(response.status).to eq(200)
      expect(assigns(:feedback_targets)).to eq([feedback_target])
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
    it 'creates a new feedback_target' do
      expect(subject.current_user.feedback_targets.count).to eq(0)
      post :create, :feedback_target => { :name => 'new app' }
      expect(subject.current_user.feedback_targets.count).to eq(1)
    end

    it 'does not create feedback_target if name is blank' do
      expect(subject.current_user.feedback_targets.count).to eq(0)
      post :create, :feedback_target => { :name => '' }
      expect(response.status).to eq(200)
      expect(assigns(:feedback_target).errors[:name]).to include("can't be blank")
    end

    it 're-show new if name is missing' do
      expect(subject.current_user.feedback_targets.count).to eq(0)
      post :create, :feedback_target => { :name => '' }
      expect(response.status).to eq(200)
      expect(response).to render_template(:new)
    end
    it 'redirects to #index after creates successfully' do
      expect(subject.current_user.feedback_targets.count).to eq(0)
      post :create, :feedback_target => { :name => 'new app' }
      expect(response.status).to eq(302)
      expect(response).to redirect_to(feedback_targets_path)
    end
  end

  describe "DELETE destroy" do
    it 'destroy an feedback_target' do
      user_app = subject.current_user.feedback_targets.create(name: "new app")
      expect(subject.current_user.feedback_targets.count).to eq(1)
      delete :destroy, :id => user_app.to_param
      expect(subject.current_user.feedback_targets.count).to eq(0)
    end

    it 'redirects to #index after destroy' do
      user_app = subject.current_user.feedback_targets.create(name: "new app")
      expect(subject.current_user.feedback_targets.count).to eq(1)
      delete :destroy, :id => user_app.to_param
      expect(response.status).to eq(302)
      expect(response.status).to redirect_to(feedback_targets_path)
    end
  end

  describe 'GET show' do
    it 'render page with application info' do

    end
  end

end
