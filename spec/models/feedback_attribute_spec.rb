describe FeedbackAttribute do

  let(:feedback_attribute) { FactoryGirl.build(:feedback_attribute) }

  describe '#options' do
    it 'stores options' do
        feedback_attribute.options = 'Option1,Option2'
        expect(feedback_attribute.custom_data).not_to be_nil
        expect(feedback_attribute.custom_data[:options]).to include 'Option1', 'Option2'
    end

    it 'changes options on reassigning' do
      feedback_attribute.options = 'Option1,Option2'
      expect(feedback_attribute.custom_data).not_to be_nil
      feedback_attribute.options = 'Option2,Option3'
      expect(feedback_attribute.options).to include 'Option2', 'Option3'
    end

    it 'retrieve options' do
      feedback_attribute.custom_data = {:options =>  ['Option1', 'Option2']}
      expect(feedback_attribute.options).to eq('Option1,Option2')
    end

  end

  describe '#default_value' do
    it 'stores default value' do
      feedback_attribute.default_value = "ok"
      expect(feedback_attribute.custom_data).not_to be_nil
      expect(feedback_attribute.custom_data[:value]).to eq('ok')
    end

    it 'changes default value on reassigning' do
      feedback_attribute.default_value = 'ok'
      expect(feedback_attribute.custom_data[:value]).to eq 'ok'
      feedback_attribute.default_value = 'not ok'
      expect(feedback_attribute.default_value).to eq 'not ok'
    end
  end

  describe 'label' do
    it 'returns name formatted when display label is missing' do
      attribute_without_label = FactoryGirl.build :feedback_attribute, display_label: nil, name: 'tipo_relato'

      expect(attribute_without_label.label).to eq('Tipo relato')
    end
  end

end
