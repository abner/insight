require 'rails_helper'

describe Ability do
  let!(:abilities) { Ability.abilities }

  def allowed?(user, action, subject)
    abilities.allowed?(user, action, subject)
  end

  context 'unknown permission' do
    let!(:user) { FactoryGirl.create(:registered_user) }

    it { expect(allowed?(user, :read_attribute, nil)).to eq false}
  end

  context 'target_abilities' do
    let!(:user) { FactoryGirl.create(:registered_user) }

    let(:new_feedback_target ){ FactoryGirl.build(:feedback_target) }

    let(:feedback_target) {FactoryGirl.create(:feedback_target, :owner => user)}

    let(:some_one_else_target) { FactoryGirl.create(:feedback_target) }

    it 'allow user create target' do
      expect(allowed?(user, :create_feedback_target, new_feedback_target)).to eq(true)
    end

    it 'allow user destroy target it owns' do
      expect(allowed?(user, :write_feedback_target,feedback_target)).to eq(true)
    end

    it 'not allow destroy target of another users' do
      expect(allowed?(user, :write_feedback_target,some_one_else_target)).to eq(false)
    end

  end

  describe 'form_abilities' do
    let!(:user) { FactoryGirl.create(:registered_user) }
    let!(:abilities) { Ability.abilities }
    let(:user_target) {FactoryGirl.create(:feedback_target, :owner => user)}
    let(:some_one_else_target) { FactoryGirl.create(:feedback_target) }

    let(:feedback_form) { FactoryGirl.create(:feedback_form, feedback_target: user_target) }

    let(:some_one_else_form) { FactoryGirl.create(:feedback_form, feedback_target: some_one_else_target) }

    context 'own forms' do
      it 'allows target owner write feedback form' do
        expect(allowed?(user, :write_feedback_form,feedback_form)).to eq(true)
      end

      it 'allows target owner read feedback form' do
        expect(allowed?(user, :read_feedback_form,feedback_form)).to eq(true)
      end

      it 'allows target owner destroy feedback form' do
        expect(allowed?(user, :destroy_feedback_form,feedback_form)).to eq(true)
      end
    end

    context 'some else forms' do
      it 'does not allows target owner write feedback form' do
        expect(allowed?(user, :write_feedback_form,some_one_else_form)).to eq(false)
      end

      it 'does not allows target owner read feedback form' do
        expect(allowed?(user, :read_feedback_form,some_one_else_form)).to eq(false)
      end

      it 'does not allows target owner destroy feedback form' do
        expect(allowed?(user, :destroy_feedback_form,some_one_else_form)).to eq(false)
      end
    end

  end

  describe 'feedback_abilities' do
    let!(:user) { FactoryGirl.create(:registered_user) }
    let!(:abilities) { Ability.abilities }
    let(:user_target) {FactoryGirl.create(:feedback_target, :owner => user)}
    let(:some_one_else_target) { FactoryGirl.create(:feedback_target) }

    let(:feedback_form) { FactoryGirl.create(:feedback_form, feedback_target: user_target) }
    let(:feedback_on_owned_form) { FactoryGirl.create(:feedback, feedback_form: feedback_form) }

    let(:some_one_else_form) { FactoryGirl.create(:feedback_form, feedback_target: some_one_else_target) }
    let(:some_one_else_feedback) { FactoryGirl.create(:feedback, feedback_form: some_one_else_form) }

    context 'feedbacks on owned forms' do
      it 'allow see feedback' do
        expect(allowed?(user, :list_feedbacks, feedback_form)).to eq(true)
      end
      it 'allow archive feedback' do
        expect(allowed?(user, :archive_feedback, feedback_on_owned_form)).to eq(true)
      end
      it 'allow unarchive feedback' do
        expect(allowed?(user, :unarchive_feedback, feedback_on_owned_form)).to eq(true)
      end
    end
    context 'feedbacks on some one else forms' do
      it 'does not allow see feedback' do
        expect(allowed?(user, :list_feedbacks, some_one_else_form)).to eq(false)
      end
      it 'does not allow archive feedback' do
        expect(allowed?(user, :archive_feedback, some_one_else_feedback)).to eq(false)
      end
      it 'does not allow unarchive feedback' do
        expect(allowed?(user, :unarchive_feedback, some_one_else_feedback)).to eq(false)
      end
    end
  end

  context 'comment_abilities' do
    let!(:user) { FactoryGirl.create(:registered_user) }
    let!(:abilities) { Ability.abilities }
    let(:user_target) {FactoryGirl.create(:feedback_target, :owner => user)}
    let(:some_one_else_target) { FactoryGirl.create(:feedback_target) }

    let(:feedback_form) { FactoryGirl.create(:feedback_form, feedback_target: user_target) }
    let(:feedback_on_owned_form) { FactoryGirl.create(:feedback, feedback_form: feedback_form) }
    let(:comment) { FactoryGirl.create(:comment, feedback:feedback_on_owned_form, user:user ) }

    let(:some_one_else_form) { FactoryGirl.create(:feedback_form, feedback_target: some_one_else_target) }
    let(:some_one_else_feedback) { FactoryGirl.create(:feedback, feedback_form: some_one_else_form) }

    context 'comments on feedbacks on owned forms' do
      it 'allow read comment' do
        expect(allowed?(user, :read_comment, comment)).to eq(true)
      end
      it 'allow destroy comment' do
        expect(allowed?(user, :destroy_comment, comment)).to eq(true)
      end
      it 'allow write comment' do
        expect(allowed?(user, :write_comment, comment)).to eq(true)
      end
    end

    # TODO read someone else comment
    # TODO try destroy someone else comment
    # TODO try write  someone else comment
    #context 'comments  on feedbacks on some one else forms' do
    #
    #end
  end
end
