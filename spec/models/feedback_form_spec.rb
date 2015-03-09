require 'rails_helper'

describe FeedbackForm do
  subject { FactoryGirl.create(:feedback_form) }

  describe '#system_columns' do
    it 'defines common columns for all forms' do
      expect(subject.system_columns).to include 'created_at', 'screenshot_path'
    end
  end

  describe '#all_columns' do
    let!(:attributes_setup) {
      [
        {name: 'tipo', type: 'Select'},
        {name: 'situacao', type: 'Hidden'}
      ]
    }
    let(:feedback_form) do
      attributes = []
      attributes_setup.each do |attribute_hash|
        attributes << FeedbackAttribute.new(attribute_hash)
      end
      FactoryGirl.create(:feedback_form, :feedback_attributes => attributes)
    end
    it 'is composed by feedback specific attributes plus common columns' do
      columns = %w(tipo situacao created_at screenshot_path)
      expect(feedback_form.all_columns).to include(*columns)
    end
  end

  describe '#grid_checked_coluns' do
    let!(:attributes_setup) {
      [
        {name: 'tipo', type: 'Select'},
        {name: 'situacao', type: 'Hidden'}
      ]
    }
    let(:feedback_form) do
      attributes = []
      attributes_setup.each do |attribute_hash|
        attributes << FeedbackAttribute.new(attribute_hash)
      end
      FactoryGirl.create(:feedback_form,
        feedback_attributes: attributes,
        grid_columns: ['tipo','created_at'])
    end
    it 'returns columns selected to be listed on datagrid' do
      columns = %w(tipo created_at)
      expect(feedback_form.grid_checked_columns.map {|attr| attr.name}).to include(*columns)
    end
  end

  describe '#detail_checked_columns' do
    let!(:attributes_setup) {
      [
        {name: 'tipo', type: 'Select'},
        {name: 'situacao', type: 'Hidden'}
      ]
    }
    let(:feedback_form) do
      attributes = []
      attributes_setup.each do |attribute_hash|
        attributes << FeedbackAttribute.new(attribute_hash)
      end
      FactoryGirl.create(:feedback_form,
        feedback_attributes: attributes,
        detail_columns: ['tipo','screenshot_path'])
    end
    it 'returns columns selected to be listed on detail panel' do
      columns = %w(tipo screenshot_path)
      expect(feedback_form.detail_checked_columns.map {|attr| attr.name}).to include(*columns)
    end
  end

  describe '#extract_description' do
    let!(:attributes_setup) {
      [
        {name: 'tipo', type: 'Select'},
        {name: 'relato', type: 'Textarea'},
        {name: 'situacao', type: 'Hidden'}
      ]
    }
    let(:feedback_form) do
      attributes = []
      attributes_setup.each do |attribute_hash|
        attributes << FeedbackAttribute.new(attribute_hash)
      end
      FactoryGirl.create(:feedback_form,
        feedback_attributes: attributes,
        description_columns: ['relato'])
    end

    let(:feedback) do
      feedback = FactoryGirl.create(:feedback, feedback_form: feedback_form)
      feedback.write_attribute(:relato, 'blablabla' )
      feedback
    end

    it 'returns a text composed by values of fields listed on description_columns' do
      expect(feedback_form.extract_description(feedback)).to eq('blablabla')
    end
  end

  describe '#columns_for_detail_setup' do
    let!(:attributes_setup) {
      [
        {name: 'tipo', type: 'Select'},
        {name: 'relato', type: 'Textarea'},
        {name: 'situacao', type: 'Hidden'}
      ]
    }
    let(:feedback_form) do
      attributes = []
      attributes_setup.each do |attribute_hash|
        attributes << FeedbackAttribute.new(attribute_hash)
      end
      FactoryGirl.create(:feedback_form, feedback_attributes: attributes)
    end
    it 'lists columns to be selected for detail panel' do
      expect(feedback_form.columns_for_detail_setup.map {|attr| attr.name}).to include 'relato'
    end

    it 'lists checked columns first' do
      feedback_form.detail_columns = ['created_at']
      expect(feedback_form.columns_for_detail_setup.first.name).to eq('created_at')
    end

  end


    describe '#columns_for_grid_setup' do
      let!(:attributes_setup) {
        [
          {name: 'tipo', type: 'Select'},
          {name: 'relato', type: 'Textarea'},
          {name: 'situacao', type: 'Hidden'}
        ]
      }
      let(:feedback_form) do
        attributes = []
        attributes_setup.each do |attribute_hash|
          attributes << FeedbackAttribute.new(attribute_hash)
        end
        FactoryGirl.create(:feedback_form, feedback_attributes: attributes)
      end
      it 'lists columns to be selected for detail panel' do
        expect(feedback_form.columns_for_grid_setup.map {|attr| attr.name}).to include 'relato'
      end
    end


end
