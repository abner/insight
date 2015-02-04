require 'rails_helper'

RSpec.describe Feedback, :type => :model do

  let(:valid_feedback) do
    FactoryGirl.build(:feedback)
  end

  context 'validations' do

  end

  context 'basic attributes' do

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
    f.save
    f
  end

  it 'search for max field count on feedbacks' do
    valid_feedback.save
    f2 = feedback_extrafields
    expect(Feedback.count).to eq(2)

    expect(Feedback.max_field_count).to eq(6)
    expect(Feedback.max_field_count_for_relation(Feedback.all.limit(1).sort(_id:1))).to eq(4)

    expect(Feedback.min_field_count).to eq(4)
    expect(Feedback.min_field_count_for_relation(Feedback.all.skip(1).limit(1).sort(_id:-1))).to eq(6)
  end

  it 'return 0 on max field count if there is no feedback recorded' do
    expect(Feedback.max_field_count).to eq(0)
  end

  it 'return 0 on min field count if there is no feedback recorded' do
    expect(Feedback.min_field_count).to eq(0)
  end
end
