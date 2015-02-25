class FeedbackFormTemplate
  include Mongoid::Document

  field :name, type: String

  embeds_many :feedback_attributes, :class_name => 'FeedbackAttributeTemplate'

  validates_presence_of :name

  def self.default_template
    where(name: default_template_name).first
  end

  def self.default_template_name
    'relato_ou_sugestao'
  end

  def attributes_template
    self.attributes.except('_id')
  end
end
