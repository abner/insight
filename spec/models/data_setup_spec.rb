require 'rails_helper'

RSpec.describe DataSetup, :type => :model do

  before :each do
    DataSetup.run!
  end

  it 'creates initial attribute types' do
    expect(FeedbackAttributeType.count).to eq(7)
    #require 'debugger'; debugger
  end

  it 'creates initial attribute models' do
    expect(FeedbackAttributeModel.count).to eq(5)
  end

  context 'form_template' do
    context 'default' do

      let(:default_name) { FeedbackFormTemplate.default_template_name }

      let(:default) { FeedbackFormTemplate.where(:name => default_name).first }

      it 'has_default defined' do
        expect(FeedbackFormTemplate.default_template).not_to be_nil
      end

      it 'creates initial' do
        expect(default).not_to be_nil
      end

      it 'is relato_ou_sugestao' do
        expect(default.name).to eq(default_name)
      end

      it 'has 5 attributes' do
        expect(default.feedback_attributes.count).to eq(5)
      end

      it 'has tipo_relato attribute' do
        expect(default.feedback_attributes.where(name: 'tipo_relato').count).to eq(1)
      end

      it 'has severidade attribute' do
        expect(default.feedback_attributes.where(name: 'severidade').count).to eq(1)
      end

      it 'has situacao attribute' do
        expect(default.feedback_attributes.where(name: 'situacao').count).to eq(1)
      end

      it 'has avaliacao attribute' do
        expect(default.feedback_attributes.where(name: 'avaliacao').count).to eq(1)
      end

      it 'has relato attribute' do
        expect(default.feedback_attributes.where(name: 'relato').count).to eq(1)
      end

    end
  end
end
