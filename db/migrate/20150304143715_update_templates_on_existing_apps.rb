class UpdateTemplatesOnExistingApps < Mongoid::Migration
  def self.check_class
    begin
      UserApplication
    rescue
      return false
    end
    true
  end
  def self.up
    if check_class
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
  end

  def self.down
  end
end
