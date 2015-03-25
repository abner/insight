require 'rails_helper'
describe FeedbacksFinder do

  let(:user) { FactoryGirl.create(:user) }
  let(:feedback_target) { FactoryGirl.create(:feedback_target, owner: user) }
  let(:feedback_form) { FactoryGirl.create(:feedback_form, feedback_target: feedback_target) }

  before(:each) do
    # data load
    (1..20).each do |i|
      FactoryGirl.build(:feedback, feedback_form: feedback_form) do |f|
        f.write_attribute(:relato, "#{'%02d' % i} relato")
        f.save
      end

    end
  end

  context 'search by assignee' do

    context 'send no params to finder' do
      subject { FeedbacksFinder.new.execute(user, {}) }

      it 'finds all feedbacks when no scope is provided' do
        expect(subject.count).to eq(20)
      end
    end

    context 'sort by relato asc' do
      subject { FeedbacksFinder.new.execute(user, {sort: 'relato_asc'}) }
      it 'return items alphabetically sorted' do
        expect(subject.first.relato).to eq('01 relato')
        expect(subject.last.relato).to eq('20 relato')
      end
    end
  end
end
