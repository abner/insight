require 'rails_helper'

describe FeedbacksController, type: :controller do

  context 'registered user' do
    login_user

    #render_views
    let(:current_user) { subject.current_user}

     it "should have a current_user" do
      # note the fact that I removed the "validate_session" parameter if this was a scaffold-generated controller
      expect(subject.current_user).not_to be_nil
    end

    describe "GET index" do
      it 'assigns @feedbacks' do
        feedback_target = FactoryGirl.create(:feedback_target, owner: current_user)
        feedback_form =  FactoryGirl.create(:feedback_form, feedback_target: feedback_target)
        feedback = FactoryGirl.create(:feedback, feedback_form: feedback_form)
        get :index, feedback_target_id: feedback.feedback_target.to_param, feedback_form_id: feedback_form.id
        expect(assigns(:feedbacks)).to eq([feedback])
      end
    end

    describe 'GET #comments' do
      let!(:feedback) do
        feedback_target = FactoryGirl.create(:feedback_target, owner: current_user)
        feedback_form =  FactoryGirl.create(:feedback_form, feedback_target: feedback_target)
        feedback = FactoryGirl.create(:feedback_with_comment, feedback_form: feedback_form)
      end

      let!(:get_comments) do
        get :comments,
              feedback_target_id: feedback.feedback_target,
              feedback_form_id: feedback.feedback_form,
              id: feedback
      end

      let!(:assign_comments) do
        get_comments
        assigns(:comments)
      end

      let!(:http_response) {
        get_comments
        response
      }

      context 'assigns comments' do
        it 'not is nil' do
            expect(assign_comments).not_to be_nil
        end
        it 'has 1 comment' do
           expect(assign_comments.count).to eq(1)
         end
       end


      it 'reponse code should be 200' do
        expect(http_response.code.to_i).to eq(200)
      end

      it 'render partial comments' do
        expect(http_response).to render_template(:partial => '_comments_list')
      end

      # it 'retur' do
      #
      #   get :comments,
      #         feedback_target_id: feedback.feedback_target,
      #         feedback_form_id: feedback.feedback_form,
      #         id: feedback
      #
      #   @comments = assigns(:comments)
      #   expect(@comments.count).to eq(1)
      #   expect(@comments).to eq(feedback.comments)
      #   expect(response).to render_template(:partial => '_comments_list')
      # end
    end
    describe 'POST #add_comment' do

      it 'add comments to a feedback' do
        feedback_target = FactoryGirl.create(:feedback_target, owner: subject.current_user)
        feedback_form =  FactoryGirl.create(:feedback_form, feedback_target: feedback_target)
        feedback = FactoryGirl.create(:feedback, feedback_form: feedback_form)

        feedbacks_index_url = feedback_target_feedback_form_feedbacks_path(feedback_target, feedback_form)

        expect(feedback.reload.comments.count).to eq(0)

        post :add_comment,
              id: feedback, feedback_target_id: feedback_target,
              feedback_form_id: feedback_form,
              comment: FactoryGirl.attributes_for(:comment, :feedback => feedback)

        expect(response).to redirect_to(feedbacks_index_url)
        expect(feedback.reload.comments.count).to eq(1)
      end

      it 'remove a comment from feedback' do
        feedback_target = FactoryGirl.create(:feedback_target, owner: subject.current_user)
        feedback_form =  FactoryGirl.create(:feedback_form, feedback_target: feedback_target)
        feedback = FactoryGirl.create(:feedback_with_comment, feedback_form: feedback_form)

        feedbacks_index_url = feedback_target_feedback_form_feedbacks_path(feedback_target, feedback_form)

        expect(feedback.reload.comments.count).to eq(1)

        delete :destroy_comment,
              feedback_target_id: feedback_target,
              feedback_form_id: feedback_form,
              id: feedback,
              comment_id: feedback.comments.first

        expect(response).to redirect_to(feedbacks_index_url)
        expect(feedback.reload.comments.count).to eq(0)
      end
    end

    describe 'archive and unarchive' do
      it 'archives feedback' do
        feedback_target = FactoryGirl.create(:feedback_target, owner: subject.current_user)
        feedback_form =  FactoryGirl.create(:feedback_form, feedback_target: feedback_target)
        feedback = FactoryGirl.create(:feedback, feedback_form: feedback_form)

        feedbacks_index_url = feedback_target_feedback_form_feedbacks_path(feedback_target, feedback_form)

        post :archive, id: feedback, feedback_form_id: feedback_form, feedback_target_id: feedback_target
        expect(response).to redirect_to(feedbacks_index_url)
        expect(feedback_form.feedbacks.count).to eq(0)
        expect(Feedback.unscoped.where(id:feedback.id).first.active).to eq(false)
      end

      it 'unarchives feedback' do
        feedback_target = FactoryGirl.create(:feedback_target, owner: subject.current_user)
        feedback_form =  FactoryGirl.create(:feedback_form, feedback_target: feedback_target)
        feedback = FactoryGirl.create(:feedback, feedback_form: feedback_form, active: false)

        feedbacks_index_url = feedback_target_feedback_form_feedbacks_path(feedback_target, feedback_form)

        expect(feedback_form.feedbacks.archived.count).to eq(1)

        post :unarchive, id: feedback, feedback_form_id: feedback_form, feedback_target_id: feedback_target
        expect(response).to redirect_to(feedbacks_index_url)
        expect(feedback_form.feedbacks.archived.count).to eq(0)
        expect(Feedback.unscoped.where(id:feedback.id).first.active).to eq(true)
      end
    end
  end

  context 'expresso user' do
    login_expresso_user

    it { expect(subject.current_user).not_to be_nil }

    describe "GET index" do
      it 'assigns @feedbacks' do
        feedback_target = FactoryGirl.create(:feedback_target, owner: subject.current_user)
        feedback_form =  FactoryGirl.create(:feedback_form, feedback_target: feedback_target)
        feedback = FactoryGirl.create(:feedback, feedback_form: feedback_form)
        get :index, feedback_target_id: feedback.feedback_target.to_param, feedback_form_id: feedback_form.id
        expect(assigns(:feedbacks)).to eq([feedback])
      end
    end
  end
end
