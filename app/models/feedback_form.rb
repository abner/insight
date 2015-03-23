class FeedbackForm
  include Mongoid::Document
  include Mongoid::Slug
  # Mongoid Paranoia adds soft delete to model
  # - destroy will set deleted_at to current_time
  # - models with deleted_at defined will be ignored on default scope
  # - deleted scope is added to allow list deleted instances
  include Mongoid::Paranoia

  include Tokenable

  field :name, type: String

  embeds_many :feedback_attributes,
   cascade_callbacks: true,
   order: :position.asc,
   before_add: :set_position

  accepts_nested_attributes_for :feedback_attributes, :reject_if => :all_blank, :allow_destroy => true

  embeds_many :state_transitions, cascade_callbacks: true
  # field :state_transitions, type: Array, default: []
  accepts_nested_attributes_for :state_transitions, :reject_if => :all_blank, :allow_destroy => true

  belongs_to :feedback_target

  field :grid_columns, type: Array

  field :detail_columns, type: Array

  field :description_columns, type: Array

  field :screenshot_enabled, type: Boolean, default: true
  field :review_enabled, type: Boolean, default: true

  field :description_field_name, type: String

  validates_presence_of :name, :feedback_attributes, :feedback_target

  has_many :feedbacks, dependent: :destroy

  slug :name, history: true, scope: :feedback_target



  field :initial_state, type: Symbol

  field :state_field, type: String
  field :state_field_label, type: String

  # before_save :check_state_consistence
  #
  # def check_state_consistence
  #   unless self.state_field.nil?
  #     #check if initial state value and attribute default value are the same
  #      if self.initial_state.present?
  #        state_attribute =  self.feedback_attributes.find_by(name: self.state_field)
  #        unless state_attribute.default_value.eql?(self.initial_state)
  #          #fix feedbacks values
  #          state_attribute.default_value =  self.initial_state
  #        end
  #      end
  #   end
  # end

  def system_columns
    @system_columns ||= {
      self.state_field => self.state_field_label,
      'created_at' => I18n.translate('feedback.created_date'),
      'screenshot_path' => I18n.translate('feedback.screenshot')
    }
    @system_columns
  end

  def all_columns
    feedback_attributes.collect {|x| x.name } + system_columns.keys
  end

  def grid_checked_columns
    columns = []
    if grid_columns and grid_columns.size > 0
      attributes = grid_columns.each do |column_name|
        if system_columns.keys.include? column_name
          columns << FeedbackAttribute.new(name: column_name, :display_label => system_columns[column_name])
        else
          columns << feedback_attributes.where(name: column_name).first
        end
      end
    end
    columns.compact
  end

  def detail_checked_columns
    columns = []
    if detail_columns and detail_columns.size > 0
      attributes = detail_columns.each do |column_name|
        if system_columns.keys.include? column_name
          columns << FeedbackAttribute.new(name: column_name, :display_label => system_columns[column_name])
        else
          columns << feedback_attributes.where(name: column_name).first
        end
      end
    end
    columns.compact
  end

  def columns_for_detail_setup
    columns_for_setup(self.detail_columns || [], detail_checked_columns)
  end

  def columns_for_grid_setup
    columns_for_setup(self.grid_columns || [], grid_checked_columns)
  end

  def columns_for_setup(selected_array, checked_columns)
    columns = []

    if selected_array and selected_array.size > 0

      columns = checked_columns

      unchecked_attributes = all_columns - selected_array

      unchecked_attributes.each do |column_name|
        column = feedback_attributes.where(name: column_name).first
        if column.nil? and system_columns.keys.include? column_name
          if feedback_attributes.select {|c| c.name.eql? column_name }.compact.count.eql?(0)
            columns << FeedbackAttribute.new(name: column_name, :display_label => system_columns[column_name])
          end
        else
          columns << column
        end
      end
      columns.compact
    else
      attributes = feedback_attributes
      sys_columns = system_columns
      sys_columns.each_pair do |name, label|
        if feedback_attributes.select {|c| c.name.eql? name }.compact.count.eql?(0)
          FeedbackAttribute.new(name: name, :display_label => label)
        end
      end

      attributes
    end
  end

  def extract_description(feedback)
    if self.description_field_name
      return feedback.read_attribute(description_field_name)
    end
    return nil unless feedback
    return attributes.values.to_s unless description_columns
    description_values = description_columns.map do |column|
      feedback.read_attribute(column) if feedback.attributes.has_key? column
    end
    description_values.join(" ")
  end

  def build_transitions_hash
    state_transitions.map do |transition|
      { transition.state.to_sym => transition.result_state.to_sym, on: transition.action.to_sym }
    end
  end

protected
  def set_position(attribute)
    if attribute and 0.eql?(attribute.position)
      attribute.position = self.feedback_attributes.count
    end
  end



end
