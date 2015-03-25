require 'rails_helper'
describe FeedbacksFinder do

  let(:user) { FactoryGirl.create(:user) }
  let(:feedback_target) { FactoryGirl.create(:feedback_target, owner: user) }
  let(:feedback_form) { FactoryGirl.create(:feedback_form, feedback_target: feedback_target) }


    context 'send no params to finder' do
      before(:each) do
        # data load
        (1..20).each do |i|
          FactoryGirl.create(:feedback, feedback_form: feedback_form) do |f|
            f.write_attribute(:relato, "#{'%02d' % i} relato")
            new_created_at = f.read_attribute(:created_at) + (i * 5)
            f.write_attribute(:created_at, new_created_at)
            f.save
          end

        end
      end
      subject { FeedbacksFinder.new.execute(user, {}) }

      it 'finds all feedbacks when no scope is provided' do
        expect(subject.count).to eq(20)
      end
    end

    context 'sort by relato asc' do

      subject { FeedbacksFinder.new.execute(user, {sort: 'relato.asc'}).to_a }

      let!(:first) do
        FactoryGirl.create(:feedback, feedback_form: feedback_form) do |f|
          f.write_attribute(:relato, '01 relato' )
        end
      end

      let!(:second) do
        FactoryGirl.create(:feedback, feedback_form: feedback_form) do |f|
          f.write_attribute(:relato, '02 relato' )
        end
      end

      it 'return items alphabetically sorted' do
        expect(subject.first).to eq(first)
        expect(subject.last).to eq(second)
      end
    end

    context 'sort by created_at' do
      before(:each) {
        FactoryGirl.build(:feedback, feedback_form: feedback_form) do |f|
          f.write_attribute(:created_at, 3.days.ago )
          f.save
        end
        FactoryGirl.build(:feedback, feedback_form: feedback_form) do |f|
          f.write_attribute(:created_at, 2.days.ago )
          f.save
        end
      }

      let(:oldest) do
        Feedback.order_by(:created_at.desc).first
      end

      let(:newest) do
        Feedback.order_by(:created_at.asc).first
      end

      context 'descending order' do
        let(:find_obj) { FeedbacksFinder.new.execute(user, {sort: 'created_at.desc'})  }

        subject { find_obj.map {|f| f.read_attribute(:created_at) } }

        it { is_expected.to match([oldest.read_attribute(:created_at), newest.read_attribute(:created_at)]) }
      end



      context 'ascending order' do
        let(:find_obj) { FeedbacksFinder.new.execute(user, {sort: 'created_at.asc'})  }

        subject { find_obj.map {|f| f.read_attribute(:created_at) } }

        it { is_expected.to match([newest.read_attribute(:created_at), oldest.read_attribute(:created_at)]) }
      end
    end
  #end
end
