class PricingType < ActiveRecord::Base
  belongs_to :type
  belongs_to :gizmo_type
  has_and_belongs_to_many :pricing_components
  define_amount_methods_on :base_value
  define_amount_methods_on :multiplier

  validates_presence_of :name
  validates_presence_of :matcher, :if => Proc.new{|t| !t.pull_from.blank?}, :message => "is required if there is a pulled value"
  validates_presence_of :pull_from, :if => Proc.new{|t| !t.matcher.blank?}, :message => "is required if there is a value to match"

  named_scope :automatic, :conditions => ["(pull_from IS NOT NULL AND pull_from <> '') OR type_id IS NOT NULL"]

  HUMAN_NAMES = {:matcher => "Value to match", :pull_from => "Pulled value"}

  def self.human_attribute_name(attr)
    HUMAN_NAMES[attr.to_sym] || super
  end

  def matches?(pricing_hash)
    matches = true
    checked = false
    if matches && self.type_id
      matches = pricing_hash[:build_type] == self.type.name
      checked = true
    end
    if matches && self.pull_from
      matches = SystemPricing.does_match?(self.matcher, pricing_hash[self.pull_from.to_sym])
      checked = true
    end
    return matches && checked
  end
end