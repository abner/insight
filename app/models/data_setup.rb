# encoding: UTF-8
class DataSetup
  class << self
    def run!
      create_attributes_types!
      create_attributes_models!
      create_templates!
      fill_apps!
      transfer_feedbacks!
    end

private

    #fill user_application with current template
    def fill_apps!
      UserApplication.all.each do |app|
        puts "Processando app #{app.name}"
        if app.default_feedback_form.nil?
          puts 'app com default form nil'
          if app.feedback_forms.empty?
            puts 'não tem form - criando um'
            form_attributes = FeedbackFormTemplate.default_template.attributes_template
            form = app.feedback_forms.create! form_attributes
            #set as default form for this user_application
            puts 'definindo form'
            app.set_default_form! form
          else
            puts 'já tinha form - definindo primeiro form como default'
            puts "#{app.feedback_forms.first.inspect}"
            app.set_default_form! app.feedback_forms.first
          end
          puts "Defaut form gravado: #{app.default_feedback_form.inspect}"
          app.reload
          puts "Defaut form gravado #after_reload: #{app.default_feedback_form.inspect}"
        end
      end
    end

    def transfer_feedbacks!
      UserApplication.all.each do |app|
        if(app.default_feedback_form.feedbacks.empty? && app.feedbacks.count > 0)
          app.feedbacks.each do |feedback|
            feedback.update_attribute(:feedback_form, app.default_feedback_form) if feedback.feedback_form.nil?
          end
        end
      end
    end

    def attribute_type_by_name name
      FeedbackAttributeType.find_by(name: name)
    end

    def attributes_by_name name
      FeedbackAttributeModel.template_for name
    end

    def create_attributes_types!
      #Loading required data to database
      if FeedbackAttributeType.count == 0
        # creating feedback data types
        FeedbackAttributeType.create! name: 'Screenshot', description: 'Captura de tela'
        FeedbackAttributeType.create! name: 'Text', description: 'Campo Texto'
        FeedbackAttributeType.create! name: 'Select', description: 'Campo Lista de Seleção'
        FeedbackAttributeType.create! name: 'StarRating', description: 'Nota em Estrelas'
        FeedbackAttributeType.create! name: 'Textarea', description: 'Campo Texto de Múltiplas Linhas'
        FeedbackAttributeType.create! name: 'Hidden', description: 'Campo Escondido'
        FeedbackAttributeType.create! name: 'Radio', description: 'Campo Seleção [Radio Button]'
      end
    end



    def create_tipo_relato_attribute_model
      FeedbackAttributeModel.create do |attribute|
        attribute.name = 'tipo_relato'
        attribute.display_label = "Tipo de Relato"
        attribute.type = attribute_type_by_name('Select')
        attribute.required = true
        attribute.custom_data = {:options => ['Sugestão', 'Erro']}
        attribute.save!
      end
    end

    def create_severidade_attribute_model
      FeedbackAttributeModel.create do |attribute|
        attribute.name = 'severidade'
        attribute.display_label = "Severidade"
        attribute.type = attribute_type_by_name('Select')
        attribute.required = true
        attribute.custom_data = {:options => ['Leve', 'Média', 'Crítica']}
        attribute.save!
      end
    end

    def create_avaliacao_attribute_model
      FeedbackAttributeModel.create do |attribute|
        attribute.name = 'avaliacao'
        attribute.display_label = "Avaliacao"
        attribute.type = attribute_type_by_name('StarRating')
        attribute.required = true
        attribute.custom_data = {:options => ["Insatisfeito", "2", "3", "4", "Muito Satisfeito"]}
        attribute.save!
      end
    end

    def create_relato_attribute_model
      FeedbackAttributeModel.create do |attribute|
        attribute.name = 'relato'
        attribute.display_label = "Relato"
        attribute.type = attribute_type_by_name('Textarea')
        attribute.required = true
        attribute.save!
      end
    end

    def create_situcao_attribute_model
      FeedbackAttributeModel.create do |attribute|
        attribute.name = 'situacao'
        attribute.display_label = ""
        attribute.type = attribute_type_by_name('Hidden')
        attribute.custom_data = {value: 'aberta'}
        attribute.required = true
        attribute.save!
      end
    end

    def create_attributes_models!
      if FeedbackAttributeModel.count.eql? 0
        create_tipo_relato_attribute_model
        create_severidade_attribute_model
        create_avaliacao_attribute_model
        create_relato_attribute_model
        create_situcao_attribute_model
      end
    end

    def create_templates!
      if FeedbackFormTemplate.count == 0
        # creating feedback form templates
        FeedbackFormTemplate.create name: 'Relato ou Sugestão' do |template|
          template.save!
          template.feedback_attributes.create!(attributes_by_name('tipo_relato'))
          template.feedback_attributes.create!(attributes_by_name('severidade'))
          template.feedback_attributes.create!(attributes_by_name('avaliacao'))
          template.feedback_attributes.create!(attributes_by_name('relato'))
          template.feedback_attributes.create!(attributes_by_name('situacao'))
          template.save!
        end
        return true
      end
      return false
    end
  end
end
