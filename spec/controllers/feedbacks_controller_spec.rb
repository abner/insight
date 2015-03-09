require 'rails_helper'

describe FeedbacksController, :type => :controller do

  context 'registered user' do
    login_user

    render_views


     it "should have a current_user" do
      # note the fact that I removed the "validate_session" parameter if this was a scaffold-generated controller
      expect(subject.current_user).not_to be_nil
    end

    describe "GET index" do
      it 'assigns @feedbacks' do
        feedback_target = FactoryGirl.create(:feedback_target, :owner => subject.current_user)
        feedback_form =  FactoryGirl.create(:feedback_form, :feedback_target => feedback_target)
        feedback = FactoryGirl.create(:feedback, :feedback_form => feedback_form)
        get :index, :feedback_target_id => feedback.feedback_target.to_param, :feedback_form_id => feedback_form.id
        puts response.body
        expect(assigns(:feedbacks)).to eq([feedback])
      end
    end
  end

  context 'expresso user' do
    login_expresso_user

    it { expect(subject.current_user).not_to be_nil }

    describe "GET index" do
      it 'assigns @feedbacks' do
        feedback_target = FactoryGirl.create(:feedback_target, :owner => subject.current_user)
        feedback_form =  FactoryGirl.create(:feedback_form, :feedback_target => feedback_target)
        feedback = FactoryGirl.create(:feedback, :feedback_form => feedback_form)
        get :index, :feedback_target_id => feedback.feedback_target.to_param, :feedback_form_id => feedback_form.id
        expect(assigns(:feedbacks)).to eq([feedback])
      end
    end
  end
end
