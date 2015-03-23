class RemoveSituacaoFromRelatoOuSugestaoTemplate < Mongoid::Migration
  def self.up
    FeedbackFormTemplate.find_by(name: 'Relato ou Sugestão') do |template|
      template.feedback_attributes.find_by(name: 'situacao').destroy
    end
  end

  def self.down
    FeedbackFormTemplate.find_by(name: 'Relato ou Sugestão') do |template|
      template.feedback_attributes.create!(FeedbackAttributeModel.template_for('situacao'))
    end
  end
end
