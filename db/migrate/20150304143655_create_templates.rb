class CreateTemplates < Mongoid::Migration
  def self.up
    FeedbackFormTemplate.create name: 'Relato ou Sugestão' do |template|
      template.save!
      template.feedback_attributes.create!(FeedbackAttributeModel.template_for('tipo_relato'))
      template.feedback_attributes.create!(FeedbackAttributeModel.template_for('severidade'))
      template.feedback_attributes.create!(FeedbackAttributeModel.template_for('avaliacao'))
      template.feedback_attributes.create!(FeedbackAttributeModel.template_for('relato'))
      template.feedback_attributes.create!(FeedbackAttributeModel.template_for('situacao'))
      template.save!
    end
  end

  def self.down
    FeedbackFormTemplate.where(name: 'Relato ou Sugestão').first.destroy
  end
end
