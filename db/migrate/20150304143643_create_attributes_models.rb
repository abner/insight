class CreateAttributesModels < Mongoid::Migration
  def self.up
    FeedbackAttributeModel.create do |attribute|
      attribute.name = 'tipo_relato'
      attribute.display_label = "Tipo de Relato"
      attribute.type = FeedbackAttributeType.where(name: 'Select').first
      attribute.required = true
      attribute.custom_data = {:options => ['Sugestão', 'Erro']}
      attribute.save!
    end

    FeedbackAttributeModel.create do |attribute|
      attribute.name = 'severidade'
      attribute.display_label = "Severidade"
      attribute.type = FeedbackAttributeType.where(name: 'Select').first
      attribute.required = true
      attribute.custom_data = {:options => ['Leve', 'Média', 'Crítica']}
      attribute.save!
    end

    FeedbackAttributeModel.create do |attribute|
      attribute.name = 'avaliacao'
      attribute.display_label = "Avaliacao"
      attribute.type = FeedbackAttributeType.where(name: 'StarRating').first
      attribute.required = true
      attribute.custom_data = {:options => ["Insatisfeito", "2", "3", "4", "Muito Satisfeito"]}
      attribute.save!
    end

    FeedbackAttributeModel.create do |attribute|
      attribute.name = 'relato'
      attribute.display_label = "Relato"
      attribute.type = FeedbackAttributeType.where(name: 'Textarea').first
      attribute.required = true
      attribute.save!
    end

    FeedbackAttributeModel.create do |attribute|
      attribute.name = 'situacao'
      attribute.display_label = ""
      attribute.type = FeedbackAttributeType.where(name: 'Hidden').first
      attribute.custom_data = {value: 'aberta'}
      attribute.required = true
      attribute.save!
    end
  end

  def self.down
    %w(tipo_relato severidade avaliacao relato situacao).each do |name|
      FeedbackAttributeModel.where(name: name).first.destroy
    end
  end
end
