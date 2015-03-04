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
      feedback_form =  FactoryGirl.create(:feedback_form, :user_application => user_application)
      feedback = FactoryGirl.create(:feedback, :feedback_form => feedback_form)
      get :index, :user_application_id => feedback.user_application.to_param, :feedback_form_id => feedback_form.id
      expect(assigns(:feedbacks)).to eq([feedback])
    end
  end
end
