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
end
