class FeedbackAttribute
  include Mongoid::Document

  belongs_to :type, :class_name => 'FeedbackAttributeType'

  field :name, type:String
  field :display_label, type:String
  field :custom_data, type:Hash
  field :required, type: Boolean, default: false
  field :position, type: Numeric, default: 0

  embedded_in :feedback_form

  before_create :set_position

  def options= value
    if value
      arr = value.split(',')
      if arr.size > 0
        arr = arr.map {|x| x.strip if x && !x.empty?}
      end
      custom_data[:options]= arr.compact!
    end
  end

  def options
    custom_data[:options].join(',') if custom_data and custom_data[:options]
  end

  def default_value= value
    if value
      custom_data[:value] = value
    end
  end

  def default_value
    custom_data[:value] if custom_data
  end

  def label
    display_label.present? ?  display_label : name.humanize if display_label
  end

  validates_presence_of :name

  def set_position
    position = feedback_form.feedback_attributes.count
  end

end
