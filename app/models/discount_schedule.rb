class DiscountSchedule < ActiveRecord::Base
  validates_uniqueness_of :name
  validates_presence_of :name
  has_many :discount_schedules_gizmo_types
  has_many :gizmo_types, :through => :discount_schedules_gizmo_types

  def multiplier_for(type)
    data = discount_schedules_gizmo_types.detect {|bridge| bridge.gizmo_type_id == type.id}
    data ? data.multiplier : nil
  end

  def self.no_discount
    @@no_discount ||= find_by_name("no_discount")
  end
end
