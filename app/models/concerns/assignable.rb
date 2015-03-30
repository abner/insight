module Assignable
  extend ActiveSupport::Concern

  included do
    belongs_to :assignee, class_name: "User", index: true

    accepts_nested_attributes_for :assignee, :reject_if => :all_blank, :allow_destroy => true

    scope :assigned_to, ->(u) { where(assignee_id: u.id)}
  end

  def is_assigned?
    !!assignee_id
  end

  def is_being_reassigned?
    assignee_id_changed?
  end


end
