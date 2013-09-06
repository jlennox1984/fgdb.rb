class PricingValue < ActiveRecord::Base
  has_and_belongs_to_many :system_pricings
  belongs_to :pricing_component
  define_amount_methods_on :value
  belongs_to :replaced_by, :foreign_key => "replaced_by_id", :class_name => "PricingType"
  scope :active, where(:ineffective_on => nil)
  validates_presence_of :name, :unless => :is_passthrough
  validates_presence_of :value_cents

  def is_passthrough
    self.pricing_component.use_value_as_score
  end

  def replaced?
    !! self.replaced_by
  end

  def finally_replaced_by
    self.replaced_by ? self.replaced_by.finally_replaced_by : self
  end

  def match_against
    (self.matcher && self.matcher.length > 0) ? self.matcher : self.name
  end

  def matches?(value)
    if self.pricing_component && self.pricing_component.numerical && self.minimum && self.maximum
      i = value.to_i
      return i >= self.minimum && i <= self.maximum
    else
      return SystemPricing.does_match?(match_against, value)
    end
  end
end
