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

  belongs_to :feedback_target

  field :grid_columns, type: Array

  field :detail_columns, type: Array

  field :screenshot_enabled, type: Boolean, default: true
  field :review_enabled, type: Boolean, default: true

  validates_presence_of :name, :feedback_attributes, :feedback_target

  has_many :feedbacks, dependent: :destroy

  def system_columns
    @system_columns ||= {
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
    columns_for_setup(self.detail_columns, detail_checked_columns)
  end

  def columns_for_grid_setup
    columns_for_setup(self.grid_columns, grid_checked_columns)
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


  slug :name, history: true, scope: :feedback_target

protected
  def set_position(attribute)
    if attribute and 0.eql?(attribute.position)
      attribute.position = self.feedback_attributes.count
    end
  end



end
