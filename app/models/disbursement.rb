class Disbursement < ActiveRecord::Base
  include GizmoTransaction
  belongs_to :contact
  belongs_to :disbursement_type
  has_many :gizmo_events, :dependent => :destroy
  has_many :gizmo_types, :through => :gizmo_events
  acts_as_userstamp

  def gizmo_context
    GizmoContext.disbursement
  end

  def validate
    validate_inventory_modifications
    unless is_adjustment?
    errors.add_on_empty("contact_id")
    if contact_id.to_i == 0
      errors.add("contact_id", "does not refer to any single, unique contact")
    end
    end
    errors.add_on_empty("disbursed_at", "when?")
    errors.add_on_empty("disbursement_type_id")
    errors.add_on_empty("gizmo_events")
  end

  before_save :set_occurred_at_on_gizmo_events

  class << self
    def default_sort_sql
      "disbursements.disbursed_at DESC"
    end
  end

  def recipient
    contact
  end
end
