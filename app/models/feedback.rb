class Feedback
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps::Created

  # Mongoid Paranoia adds soft delete to model
  # - destroy will set deleted_at to current_time
  # - models with deleted_at defined will be ignored on default scope
  # - deleted scope is added to allow list deleted instances
  include Mongoid::Paranoia

  # before_create do
  #   self.feedback_target = feedback_form.feedback_target
  # end

  #belongs_to :feedback_target (replaced by methods to avoid duplication and inconsistence)

  belongs_to :feedback_form

  field :server_date_time, type: DateTime

  field :screenshot_path

  field :text, type: String

  field :category, type: String

  field :screenshot_path, type: String

  embeds_one :feedback_requester

  field :active, type: Boolean, :default => true

  scope :active, -> { where(active: true)}

  default_scope -> { where(active: true) }

  scope :archived, -> { where(active: false) }

  embeds_many :comments

  def feedback_target
    feedback_form.feedback_target if feedback_form
  end

  def feedback_target_id
    feedback_form.feedback_target.id if feedback_form
  end

  #pagination definition
  def self.per_page
    10
  end

  def description
    feedback_form.extract_description(self) if feedback_form
  end

  def archive!
    self.active = false
    self.save!
    self
  end

  def unarchive!
    self.active = true
    self.save
    self
  end

  #validates_presence_of :text

  before_save :fill_automatic_fields

  def view_id
    id.to_s
  end

  def columns
    columns = self.attributes.reject do |k,v|
      k == "feedback_target_id"
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
    #puts "RELATION: #{relation.inspect} "
    reduce = relation.map_reduce(object_attributes_count_map, number_array_max_value_reduce).out(:inline => true)
    #puts reduce.send(:command).send(:inspect)
    #puts "INPUT: #{reduce.input}"
    #puts "REDUCED: #{reduce.reduced}"
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

  def self.last_feedbacks_for_user(user)
    apps_ids = FeedbackTarget.all_targets_for_user(user).map {|app| app.id.to_s }
    forms_ids = FeedbackForm.in(feedback_target_id: apps_ids).map {|form| form.id.to_s}
    Feedback.in(feedback_form_id: forms_ids).order(created_at: 'DESC').paginate(page: 1, per_page: 5)
  end

protected
    def fill_automatic_fields
      #check app region information
      self.server_date_time = DateTime.now
    end
end
