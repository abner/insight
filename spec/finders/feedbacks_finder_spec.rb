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

    context 'sort by relato' do

      context 'ascending order' do
        subject { FeedbacksFinder.new.execute(user, {sort: 'relato.asc'}) }

        let!(:prefixed_01) do
          relato_value = '01 relato'
          FactoryGirl.create(:feedback, feedback_form: feedback_form) do |f|
            f.write_attribute(:relato, relato_value)
            f.save
          end
          relato_value
        end

        let!(:prefixed_02) do
          relato_value = '02 relato'
          FactoryGirl.create(:feedback, feedback_form: feedback_form) do |f|
            f.write_attribute(:relato, relato_value)
            f.save
          end
          relato_value
        end


        its("first.attributes") { is_expected.to include({ "relato" => prefixed_01 }) }
        its("last.attributes")  { is_expected.to include({ "relato" => prefixed_02 }) }
      end

      context 'descending order' do
        subject { FeedbacksFinder.new.execute(user, {sort: 'relato.desc'}) }

        let!(:prefixed_01) do
          relato_value = '01 relato'
          FactoryGirl.create(:feedback, feedback_form: feedback_form) do |f|
            f.write_attribute(:relato, relato_value)
            f.save
          end
          relato_value
        end

        let!(:prefixed_02) do
          relato_value = '02 relato'
          FactoryGirl.create(:feedback, feedback_form: feedback_form) do |f|
            f.write_attribute(:relato, relato_value)
            f.save
          end
          relato_value
        end


        its("first.attributes") { is_expected.to include({"relato" => prefixed_02}) }
        its("last.attributes")  { is_expected.to include({"relato" => prefixed_01}) }
      end
    end

    context 'find assigned to a user' do
      before(:each) do
        # 20 feedbacks to db just to be sure find only returns matching records
        (1..20).each {|i| FactoryGirl.create(:feedback, feedback_form: feedback_form) }
      end

      subject { FeedbacksFinder.new.execute(user, {assignee_id: user.id }) }

      let!(:assigned_to_user) do
        FactoryGirl.create(:feedback, feedback_form: feedback_form, assignee: user) do |f|
          f.write_attribute(:relato, 'assigned to user')
          f.save
        end
      end

      its(:count) { is_expected.to eq(1) }

      it 'returns only feedback assigned to user' do
        expect(subject.to_a).to match([assigned_to_user])
      end

    end

    context 'sort by created_at' do
      before(:each) do
        FactoryGirl.build(:feedback, feedback_form: feedback_form) do |f|
          f.write_attribute(:created_at, 3.days.ago )
          f.save
        end
        FactoryGirl.build(:feedback, feedback_form: feedback_form) do |f|
          f.write_attribute(:created_at, 2.days.ago )
          f.save
        end
      end

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
