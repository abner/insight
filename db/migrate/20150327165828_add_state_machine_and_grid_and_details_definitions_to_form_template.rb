class AddStateMachineAndGridAndDetailsDefinitionsToFormTemplate < Mongoid::Migration
  def self.up
    FeedbackFormTemplate.find_by(name: 'Relato ou Sugestão') do |template|
      template.initial_state = 'aberto'
      template.state_field = 'state'
      template.state_field_label = 'Situação'
      template.grid_columns = %w(created_at relato tipo_relato severidade avaliacao situacao)
      template.detail_columns = %w(created_at relato tipo_relato severidade avaliacao situacao)
      template.description_field_name = 'relato'
      template.screenshot_enabled = true
      template.review_enabled = true
      transitions = [
        {"state"=>:aberto, "action"=>:admitir, "result_state"=>:admitido},
        {"state"=>:aberto, "action"=>:rejeitar, "result_state"=>:rejeitado},
        { "state"=>:aberto, "action"=>:admitir, "result_state"=>:admitido},
        {"state"=>:admitido, "action"=>:resolver, "result_state"=>:resolvido},
        { "state"=>:admitido, "action"=>:cancelar, "result_state"=>:cancelado},
        {"state"=>:resolvido, "action"=>:confirmar, "result_state"=>:fechado},
        { "state"=>:resolvido, "action"=>:reabrir, "result_state"=>:admitido}
      ]
      template.state_transitions_attributes = transitions
      template.save!
    end
  end

  def self.down
    FeedbackFormTemplate.find_by(name: 'Relato ou Sugestão') do |template|
      template.initial_state = nil
      template.state_field = nil
      template.state_field_label = nil
      template.grid_columns = []
      template.detail_columns = []
      template.description_field_name = nil
      template.screenshot_enabled = nil
      template.review_enabled = nil
      template.state_transitions.destroy
      template.save!
    end
  end
end
