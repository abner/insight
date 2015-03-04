require 'rails_helper'

RSpec.describe Feedback, :type => :model do

  let(:valid_feedback) do
    FactoryGirl.build(:feedback)
  end

  let(:inactive_feedback) do
    FactoryGirl.build(:feedback, active: false)
  end

  context 'validations' do

  end

  context 'basic attributes' do

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
    f2 = feedback_extrafields
    expect(Feedback.count).to eq(2)

    expect(Feedback.max_field_count).to eq(10)
    expect(Feedback.max_field_count_for_relation(Feedback.all.limit(1).sort(_id:1))).to eq(8)

    expect(Feedback.min_field_count).to eq(8)
    expect(Feedback.min_field_count_for_relation(Feedback.all.skip(1).limit(1).sort(_id:-1))).to eq(10)
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
