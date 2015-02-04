class Feedback
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  belongs_to :user_application

  field :server_date_time, type: DateTime

  field :screenshot_path

  field :text, type: String

  field :category, type: String

  field :screenshot_path, type: String

  embeds_one :feedback_requester

  #pagination definition
  def self.per_page
    10
  end


  #validates_presence_of :text

  before_save :fill_automatic_fields

  def view_id
    id.to_s
  end

  def columns
    columns = self.attributes.reject do |k,v|
      k == "user_application_id"
    end
    columns.map do |c|
      { :key => c[0], :value => c[1]}
    end.flatten
  end


#MAP REDUCE CLASS METHODS
  def self.object_attributes_count_map
    %Q{
      function() {
        emit(1, Object.keys(this).length);
      }
    }
  end

  def self.number_array_max_value_reduce
    %Q{
      function(key, lengths) {
        return Math.max.apply(Math, lengths);
      }
    }
  end

  def self.number_array_min_value_reduce
    %Q{
      function(key, lengths) {
        return Math.min.apply(Math, lengths);
      }
    }
  end

  def self.max_field_count_for_relation(relation)
    puts "RELATION: #{relation.inspect} "
    reduce = relation.map_reduce(object_attributes_count_map, number_array_max_value_reduce).out(:inline => true)
    puts reduce.send(:command).send(:inspect)
    puts "INPUT: #{reduce.input}"
    puts "REDUCED: #{reduce.reduced}"
    result = reduce.first
    result.nil? ? 0 : result[:value]
  end

  def self.max_field_count
    self.max_field_count_for_relation(self.all)
  end


  def self.min_field_count_for_relation(relation)
    result = relation.map_reduce(object_attributes_count_map, number_array_min_value_reduce).out(:inline => true).first
    result.nil? ? 0 : result[:value]
  end

  def self.min_field_count
    self.min_field_count_for_relation(self.all)
  end


protected
    def fill_automatic_fields
      #check app region information
      self.server_date_time = DateTime.now
    end
end
