class FeedbackAttribute
  include Mongoid::Document

  belongs_to :type, :class_name => 'FeedbackAttributeType'

  field :name, type:String
  field :display_label, type:String
  field :custom_data, type:Hash
  field :required, type: Boolean, default: false
  field :position, type: Integer, default: 0

  embedded_in :feedback_form

  #before_create :set_position


  def options= value
    if value
      arr = value.split(',')
      if arr.size > 0
        arr = arr.map {|x| x.strip if x && !x.empty?}
      end
      # deep copy used to changing mongoid hash attribute (is wasn't changing using without deep_copy and reassigining)
      # SOURCE: http://spin.atomicobject.com/2011/04/13/mongoid-hash-field-types-watch-out/
      if read_attribute(:custom_data)
        hash = read_attribute(:custom_data).deep_dup
        hash[:options] = arr
      else
        hash = { options: arr }
      end
      write_attribute(:custom_data,  hash)

    end
  end

  def options
    custom_data[:options].join(',') if custom_data and custom_data[:options]
  end

  def default_value= value
    if value
      if self.read_attribute(:custom_data)
        # deep copy used to changing mongoid hash attribute (is wasn't changing using without deep_copy and reassigining)
        # SOURCE: http://spin.atomicobject.com/2011/04/13/mongoid-hash-field-types-watch-out/
        hash = self.read_attribute(:custom_data).deep_dup
        hash[:value] = value
      else
        hash = {value: value}
      end
      write_attribute(:custom_data, hash)
    end
  end

  def default_value
    custom_data[:value] if custom_data
  end

  def label
    display_label.present? ?  display_label : name.humanize #if display_label
  end

  validates_presence_of :name

  # def set_position
  #   position = feedback_form.feedback_attributes.count.to_i
  # end

end
