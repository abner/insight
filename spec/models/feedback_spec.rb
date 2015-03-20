require 'rails_helper'
require 'ap'
RSpec.describe Feedback, :type => :model do

  let(:valid_feedback) do
    FactoryGirl.build(:feedback)
  end

  let(:inactive_feedback) do
    FactoryGirl.build(:feedback, active: false)
  end

  context 'validations' do

  end

  context 'assignable' do
    subject { FactoryGirl.create(:feedback) }

    let(:user) { FactoryGirl.create(:user) }

    it 'would be assigned to an user' do
      subject.assignee = user
      subject.save!
      expect(subject.assignee).to eq(user)
    end

  end

  context 'assigned scope' do
    let(:user) { FactoryGirl.create(:user) }

    let(:feedbacks_assigned) do
      [
        FactoryGirl.create(:feedback_with_assignee, assignee: user),
        FactoryGirl.create(:feedback_with_assignee, assignee: user)
      ]
    end

    let(:feedback) { FactoryGirl.create(:feedback) }

    it 'returns feedbacks assigned to an user' do
      expect(Feedback.assigned_to(user)).to match_array(feedbacks_assigned)
    end

    it 'does not return feedback not assigned to an user' do
      expect(Feedback.assigned_to(user)).not_to include feedback
    end
  end

  context 'state machine' do
    #let(:feedback_form) { FactoryGirl.create(:feedback_form)}
    let(:feedback) { FactoryGirl.create(:feedback) }


    context 'with state machine defined' do
      let(:feedback_form_with_machine) do
        feedback.feedback_form.state_transitions = [
          FactoryGirl.build(:state_transition, state: :aberto, action: :admitir, result_state: :admitido),
          FactoryGirl.build(:state_transition, state: :admitido, action: :resolver, result_state: :resolvido),
          FactoryGirl.build(:state_transition, state: :resolvido, action: :reabrir, result_state: :reaberto),
          FactoryGirl.build(:state_transition, state: :reaberto, action: :resolver, result_state: :resolvido),
          FactoryGirl.build(:state_transition, state: :resolvido, action: :fechar, result_state: :fechado)
        ]
        feedback.feedback_form.initial_state = :aberto
        feedback.feedback_form.state_field = 'situacao'
        feedback.feedback_form.save
        feedback
      end

      it 'transites between states' do
        state_machine = feedback_form_with_machine.state_machine

        state_machine.admitir
        expect(state_machine.admitido?).to be true

        state_machine.resolver
        expect(state_machine.resolvido?).to be true

        state_machine.reabrir
        expect(state_machine.reaberto?).to be true

        state_machine.resolver
        expect(state_machine.resolvido?).to be true

        state_machine.fechar
        expect(state_machine.fechado?).to be true
      end
    end

    context 'missing state machine definitions on feedback form' do
    end
  end

  context 'basic attributes' do
    it 'is related to feedback_target through feedback_form' do
      target = FactoryGirl.create(:feedback_target)
      form = FactoryGirl.create(:feedback_form, feedback_target: target)
      feedback = form.feedbacks.build
      expect(feedback.feedback_form).not_to be_nil
      expect(feedback.feedback_target).to eq(target)
      expect(feedback.feedback_target_id).to eq(target.id)
    end
  end

  it 'is possible to recovere after destroyed' do
    feedback = valid_feedback
    feedback.save!
    feedback.destroy
    expect(Feedback.deleted.where(id: feedback.id).first).not_to be_nil
    feedback.restore
    expect(Feedback.all.where(id: feedback.id).first.id).to eq(feedback.id)
  end

  it 'cannot be restored if destroyed with destroy!' do
    feedback = valid_feedback
    feedback.save!
    feedback.destroy!
    expect(Feedback.deleted.where(id: feedback.id).first).to be_nil
  end

  it 'has a view_id method' do
    feedback = valid_feedback
    expect(feedback.view_id).not_to be_nil
    expect(feedback.view_id).to eq(feedback.id.to_s)
  end

  it 'allows define dynamic attributes' do
    feedback = valid_feedback
    feedback[:custom_attribute_created] = "Anything"

    expect(feedback.save).to be(true)

    feedback_reloaded = Feedback.find(feedback.id)
    expect(feedback[:custom_attribute_created]).to eq("Anything")
  end

  let(:feedback_extrafields) do
    f = FactoryGirl.build(:feedback)
    f.write_attribute :rating, 10
    f.write_attribute :user, 'joao'
    f.save!
    f
  end

  it 'search for max field count on feedbacks' do
    valid_feedback.save!
    min_count = valid_feedback.attributes.count
    f2 = feedback_extrafields
    max_count = f2.attributes.count
    expect(Feedback.count).to eq(2)

    expect(Feedback.max_field_count).to eq(max_count)
    expect(Feedback.max_field_count_for_relation(Feedback.all.limit(1).sort(_id:1))).to eq(min_count)

    expect(Feedback.min_field_count).to eq(min_count)
    expect(Feedback.min_field_count_for_relation(Feedback.all.skip(1).limit(1).sort(_id:-1))).to eq(max_count)
  end

  it 'return 0 on max field count if there is no feedback recorded' do
    expect(Feedback.max_field_count).to eq(0)
  end

  it 'return 0 on min field count if there is no feedback recorded' do
    expect(Feedback.min_field_count).to eq(0)
  end

  context 'active and archived scopes' do
    it 'is active when created' do
     feedback = valid_feedback
     feedback.save!
     expect(feedback.active).to eq(true)
    end

    it 'has active scope' do
      feedback_active = valid_feedback
      feedback_active.save!
      expect(Feedback.active.count).to eq(1)
    end

    it 'has archived scope' do
      feedback_inactive = inactive_feedback
      feedback_inactive.save!
      expect(Feedback.archived.count).to eq(1)
    end

    it 'separates archived from active' do
      feedback_active = valid_feedback
      feedback_active.save!

      feedback_inactive = inactive_feedback
      feedback_inactive.save!

      expect(Feedback.active.count + Feedback.archived.count).to eq(2)
      expect(Feedback.unscoped.count).to eq(2)
    end
  end

  context 'operations' do
    it 'archives' do
      feedback = FactoryGirl.create(:feedback)
      feedback.archive!
      expect(Feedback.where(id: feedback.id).first).to be_nil
      expect(Feedback.archived.where(id: feedback.id).first).to eq(feedback)
    end

    it 'unarchive' do
      feedback = FactoryGirl.create(:feedback, active: false)
      expect(Feedback.unscoped.where(id: feedback.id).first).not_to be_nil
      feedback.unarchive!
      expect(Feedback.where(id: feedback.id).first.active).to eq(true)
    end

    it 'returns columns' do
      feedback = FactoryGirl.build(:feedback)
      feedback[:tipo_relato] = 'erro'
      feedback[:relato] = 'texto relato'
      feedback.save!
      expect(feedback.columns.collect {|c| c[:key] }).to include 'tipo_relato', 'relato'
    end

    it 'returns description text based on form setup' do
      feedback = FactoryGirl.create(:feedback)
      feedback.write_attribute(:relato, 'relato descritivo')
      expect(feedback.description).to eq('relato descritivo')
    end
  end

  context 'search' do
    it 'searchs for last feedbacks for an user' do
      user = FactoryGirl.create(:user)
      feedback_target = FactoryGirl.create(:feedback_target, :owner => user)
      feedback_form = FactoryGirl.create(:feedback_form, :feedback_target => feedback_target)
      feedback = FactoryGirl.create(:feedback, :feedback_form => feedback_form)
      expect(Feedback.last_feedbacks_for_user(user).map {|f| f.id}).to include feedback.id
    end
  end

  context 'is commentable' do
    let(:valid_user) { FactoryGirl.create(:registered_user) }

    let(:feedback_with_comment) { FactoryGirl.create(:feedback_with_comment) }

    it 'accepts new comment' do
      feedback = valid_feedback
      feedback.save!
      feedback.comments.create(:user => valid_user, :text => 'New Comment')
      expect(feedback.comments.count).to eq(1)
      expect(feedback.comments.first.user.id).to eq(valid_user.id)
    end

    it 'changes comment text' do
      feedback = feedback_with_comment
      feedback.save!
      feedback.comments.first.update_attribute(:text, 'new comment text')
      expect(Feedback.find(feedback.id).comments.first.text).to eq('new comment text')
    end

    it 'destroy comment' do
      feedback = feedback_with_comment
      feedback.save!
      feedback.comments.first.destroy
      expect(feedback.comments.count).to eq(0)
    end
  end
end
