class StateTransition
  include Mongoid::Document

  field :state, type: Symbol
  field :action, type: Symbol
  field :result_state, type: Symbol

  before_save :force_downcase

  def force_downcase
    state = state.to_s.downcase.to_sym unless state.blank?
    action = action.to_s.downcase.to_sym unless action.blank?
    result_state = result_state.to_s.downcase.to_sym unless result_state.blank?
  end
end
