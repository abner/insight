class CreateAttributesTypes < Mongoid::Migration
  def self.up
    FeedbackAttributeType.create! name: 'Screenshot', description: 'Captura de tela'
    FeedbackAttributeType.create! name: 'Text', description: 'Campo Texto'
    FeedbackAttributeType.create! name: 'Select', description: 'Campo Lista de Seleção'
    FeedbackAttributeType.create! name: 'StarRating', description: 'Nota em Estrelas'
    FeedbackAttributeType.create! name: 'Textarea', description: 'Campo Texto de Múltiplas Linhas'
    FeedbackAttributeType.create! name: 'Hidden', description: 'Campo Escondido'
    FeedbackAttributeType.create! name: 'Radio', description: 'Campo Seleção [Radio Button]'
  end

  def self.down
    FeedbackAttributeType.where(name: 'Screenshot').first.destroy
    FeedbackAttributeType.where(name: 'Text').first.destroy
    FeedbackAttributeType.where(name: 'Select').first.destroy
    FeedbackAttributeType.where(name: 'StarRating').first.destroy
    FeedbackAttributeType.where(name: 'Textarea').first.destroy
    FeedbackAttributeType.where(name: 'Hidden').first.destroy
    FeedbackAttributeType.where(name: 'Radio').first.destroy
  end
end
