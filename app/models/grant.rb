class Grant < ActiveRecord::Base
  include GizmoTransaction
  belongs_to :contact, :order => "surname, first_name"
  belongs_to :grant_type
  has_many :gizmo_events, :dependent => :destroy

  def validate
    errors.add_on_empty("contact_id")
    errors.add_on_empty("grant_type_id")
    errors.add_on_empty("gizmo_events")
  end

  def recipient
    contact.display_name
  end
end
