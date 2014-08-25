require 'rails_helper'

describe FeedbacksController, :type => :controller do

  login_user


   it "should have a current_user" do
    # note the fact that I removed the "validate_session" parameter if this was a scaffold-generated controller
    expect(subject.current_user).not_to be_nil
  end

  describe "GET index" do
    it 'assigns @feedbacks' do
      user_application = FactoryGirl.create(:user_application, :owner => subject.current_user)
      feedback = FactoryGirl.create(:feedback, :user_application => user_application)
      get :index, :user_application_id => feedback.user_application.to_param
      expect(assigns(:feedbacks)).to eq([feedback])
    end
  end
end
