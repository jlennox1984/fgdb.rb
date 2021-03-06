class Donation < ActiveRecord::Base
  acts_as_userstamp

  include GizmoTransaction
  belongs_to :contact
  has_many :payments, :dependent => :destroy, :autosave => :true
  has_many :payment_methods, :through => :payments
  has_many :gizmo_events, :dependent => :destroy, :autosave => :true
  has_many :gizmo_types, :through => :gizmo_events
  has_one :resolved_by_gizmo_event, :class_name => "GizmoEvent", :foreign_key => :invoice_donation_id

  define_amount_methods_on_fake_attr :invoice_amount
  after_destroy {|rec| Thread.current['cashier'] ||= Thread.current['user']; rec.resolves.each do |d| d.invoice_resolved_at = nil; d.save!; end } # FIXME: ask for cashier code on destroy

  def receipt_types
    ['invoice', 'receipt'].reverse.select{|x| self.send('needs_' + x + '?')}
  end

  def needs_invoice?
    invoiced?
  end

  def needs_receipt?
    (!invoiced?) or (self.payments.select{|x| x.payment_method != PaymentMethod.invoice}.length > 0) or (find_lines(:is_gizmo_line?).length > 0)
  end

  def find_lines(type)
    self.gizmo_events.select{|event| GizmoEvent.send(type, event)}
  end

  def calculated_under_pay
    (money_tendered_cents + amount_invoiced_cents) - calculated_required_fee_cents
  end

  def invoice_amount_cents
    payments.select{|x| x.payment_method == PaymentMethod.invoice}.inject(0){|t,x| t+=x.amount_cents}
  end

  def resolves
    supersedes
  end

  def supersedes
    self.gizmo_events.collect{|x| x.invoice_donation}.uniq.select{|x| !!x}.sort_by(&:occurred_at)
  end

  def all_recursive_supersedes
    extras = supersedes
    oldlen = 0
    len = extras.length
    while oldlen < len
      oldlen = len
      extras = ([extras] + extras.map{|x| x.supersedes}).flatten.uniq
      len = extras.length
    end
    return extras.sort_by(&:occurred_at)
  end

  def superseded?
    !! resolved_by_gizmo_event
  end

  def superseded_by
    resolved_by_gizmo_event.donation
  end

  def has_unresolved_invoice?
    payment_methods.include?(PaymentMethod.invoice) and !resolved?
  end

  def resolved?
    !! invoice_resolved_at
  end

  def gizmo_context
    GizmoContext.donation
  end

  define_amount_methods_on("reported_required_fee")
  define_amount_methods_on("amount_invoiced")
  define_amount_methods_on("cash_donation_owed")
  define_amount_methods_on("reported_suggested_fee")

  attr_writer :contact_type #anonymous, named, or dumped

  before_save :add_contact_types
  before_save :cleanup_for_contact_type
  before_save :unzero_contact_id
  before_save :add_dead_beat_discount
  before_save :set_occurred_at_on_gizmo_events
  before_save :compute_fee_totals
  before_save :combine_cash_payments
  before_save :set_occurred_at_on_transaction
  before_save :strip_postal_code

  after_save :add_to_processor_daemon

  def self.number_by_conditions(c)
    Donation.connection.execute("SELECT count(*) FROM donations WHERE #{sanitize_sql_for_conditions(c.conditions(Donation))}").to_a[0]["count"].to_i
  end

  validate(:validate_inventory_modifications, :contact_valid_type,
           :bubble_gizmo_count, :covered_error_checking,
           :includes_payment_or_gizmo, :maximum_invoices)


  def covered_error_checking
    if Default["coveredness_enabled"] != "1" or is_adjustment?
      return
    end
    covered = Default["fully_covered_contact_covered_gizmo"].to_i
    uncovered = Default["unfully_covered_contact_covered_gizmo"].to_i
    num_choosen = self.gizmo_events_actual.select{|x| x.covered}.collect{|x| x.gizmo_count}.inject(0){|x,y| x+y}
    type = ""
    if contact_type != 'named' || contact.nil?
      type = "anon"
    else # named contact
      case self.contact.fully_covered_
      when "nil" then type = "unknown"
      when "yes" then type = "covered"
      when "no" then type = "uncovered"
      end
    end
    if type == "anon" || type == "unknown"
      if !unknown_okay(uncovered, covered, num_choosen)
        errors.add("contact_type", "must be named for donations of over #{thing(uncovered, covered)} covered items") if type == "anon"
        errors.add("contact", "must have fully_covered set for donations of over #{thing(uncovered, covered)} covered items") if type == "unknown"
      end
    end
    errors.add("gizmo_events", "may only have #{covered} covered items for contacts who are fully covered") if type == "covered" && !okay(covered, num_choosen)
    errors.add("gizmo_events", "may only have #{uncovered} covered items for contacts who are not fully covered") if type == "uncovered" && !okay(uncovered, num_choosen)
  end

  def thing(one,two)
    return nil if one == two
    return two if one == -1
    return one if two == -1
    return [one,two].min
  end
  def doesitmatter(first, second, current)
    return false if thing(first, second).nil?
    return true if current > thing(first, second)
    return false
  end
  def unknown_okay(first,second,current)
    !doesitmatter(first,second,current)
  end
  def okay(num_allowed, choosen)
    return true if num_allowed == -1
    return false if choosen > num_allowed
    return true
  end

  class << self
    def default_sort_sql
      "donations.occurred_at DESC"
    end

    def totals(conditions)
      total_data = {}
      gizmoless_data = {}
      methods = PaymentMethod.find(:all)
      methods.each {|method|
        total_data[method.id] = {'amount' => 0, 'required' => 0, 'suggested' => 0, 'count' => 0, 'min' => 1 << 64, 'max' => 0}
      }
      methods.each {|method|
        gizmoless_data[method.id] = {'amount' => 0, 'required' => 0, 'suggested' => 0, 'count' => 0, 'min' => 1 << 64, 'max' => 0}
      }
      self.connection.execute(
                              "SELECT payments.payment_method_id,
                sum(payments.amount_cents) - sum(COALESCE(gizmo_events.unit_price_cents, 0)) as amount,
                sum(donations.reported_required_fee_cents) - sum(COALESCE(gizmo_events.unit_price_cents, 0)) as required,
                sum(donations.reported_suggested_fee_cents) as suggested,
                count(*),
                min(donations.id),
                max(donations.id)
         FROM donations
         JOIN payments ON payments.donation_id = donations.id
         LEFT OUTER JOIN gizmo_types ON gizmo_types.name = 'invoice_resolved'
         LEFT OUTER JOIN gizmo_events ON gizmo_events.gizmo_type_id = gizmo_types.id
                                      AND gizmo_events.donation_id = donations.id
         WHERE #{sanitize_sql_for_conditions(conditions)}
         AND (SELECT count(*) FROM payments WHERE payments.donation_id = donations.id) = 1
         GROUP BY payments.payment_method_id"
                              ).each {|summation|
        d = {}
        summation.each{|k,v|d[k] = v.to_i}
        total_data[summation['payment_method_id'].to_i] = d
      }
       self.connection.execute("SELECT payments.payment_method_id,
                sum(payments.amount_cents) - sum(COALESCE(gizmo_events.unit_price_cents, 0)) as amount
         FROM donations
         JOIN payments ON payments.donation_id = donations.id
         LEFT OUTER JOIN gizmo_types ON gizmo_types.name = 'invoice_resolved'
         LEFT OUTER JOIN gizmo_events ON gizmo_events.gizmo_type_id = gizmo_types.id
                                      AND gizmo_events.donation_id = donations.id
         WHERE #{sanitize_sql_for_conditions(conditions)}
         AND (SELECT count(*) FROM payments WHERE payments.donation_id = donations.id) = 1
         AND (SELECT count(*) FROM gizmo_events WHERE gizmo_events.donation_id = donations.id) = 0
         GROUP BY payments.payment_method_id").each {|summation|
        d = {}
        summation.each{|k,v|d[k] = v.to_i}
        gizmoless_data[summation['payment_method_id'].to_i] = d
      }
      total_data.each{|k,v|
        total_data[k]['gizmoless_cents'] = gizmoless_data[k]['amount']
      }
      Donation.paid_by_multiple_payments(conditions).each {|donation|
        required_to_be_paid = donation.reported_required_fee_cents
        required_as_invoice = donation.gizmo_events.select{|x| x.gizmo_type.name == 'invoice_resolved'}.inject(0){|t, x| t += x.unit_price_cents}
        required_to_be_paid -= required_as_invoice
        donation.payments.sort_by(&:payment_method_id).each {|payment|
          #total paid
          amount = payment.amount_cents
          if required_as_invoice > 0
            if required_as_invoice > amount
              required_as_invoice -= amount
              amount = 0
            else
              amount -= required_as_invoice
              required_as_invoice = 0
            end
          end
          total_data[payment.payment_method_id]['count'] += 1
          total_data[payment.payment_method_id]['amount'] += amount
          if donation.gizmo_events.length > 0
            if required_to_be_paid > 0
              if required_to_be_paid > amount
                total_data[payment.payment_method_id]['required'] += amount
              else
                total_data[payment.payment_method_id]['required'] += required_to_be_paid
                total_data[payment.payment_method_id]['suggested'] += (amount - required_to_be_paid)
              end
              required_to_be_paid -= amount
            else
              total_data[payment.payment_method_id]['suggested'] += amount
            end
          else
            total_data[payment.payment_method_id]['gizmoless_cents'] += amount
          end

          total_data[payment.payment_method_id]['min'] = [total_data[payment.payment_method_id]['min'],
                                                          donation.id].min
          total_data[payment.payment_method_id]['max'] = [total_data[payment.payment_method_id]['max'],
                                                          donation.id].max
        }
      }
      return total_data.map {|method_id,sums|
        {'payment_method_id' => method_id}.merge(sums)
      }
    end

    def paid_by_multiple_payments(conditions)
      # conditions[0] += " AND (SELECT count(*) FROM payments WHERE payments.donation_id = donations.id) > 1 "
      self.where(*conditions).includes(:payments).select{|d| d.payments.length > 1}
    end
  end

  def donor
    if contact_type == 'named'
      contact.display_name
    elsif contact_type == 'anonymous'
      "anonymous(#{postal_code})"
    else
      'dumped'
    end
  end

  def contact_type
    unless @contact_type
      if contact
        @contact_type = 'named'
      elsif postal_code != '' and not postal_code.nil?
        @contact_type = 'anonymous'
      elsif id
        @contact_type = 'dumped'
      else
        @contact_type = 'named'
      end
    end
    @contact_type
  end

  def required_contact_type
    a = [ContactType.find_by_name('donor')]
    a << ContactType.find_by_name('contributor') if cash_donation_paid_cents > 0
    return a
  end

  def reported_total_cents
    reported_required_fee_cents + reported_suggested_fee_cents
  end

  def calculated_required_fee_cents
    gizmo_events_actual.inject(0) {|total, gizmo|
      next if gizmo.mostly_empty?
      total + gizmo.required_fee_cents
    }
  end

  def calculated_suggested_fee_cents
    gizmo_events_actual.inject(0) {|total, gizmo|
      total + gizmo.suggested_fee_cents
    }
  end

  def calculated_total_cents
    calculated_suggested_fee_cents + calculated_required_fee_cents
  end

  def cash_donation_owed_cents
    [0, (amount_invoiced_cents - reported_required_fee_cents) - cash_donation_paid_cents].max
  end

  def cash_donation_paid_cents
    [0, money_tendered_cents - required_fee_paid_cents].max
  end

  def required_fee_owed_cents
    if invoiced? and (reported_required_fee_cents > required_fee_paid_cents)
      [reported_required_fee_cents - required_fee_paid_cents, amount_invoiced_cents].min
    else
      0
    end
  end

  def required_fee_paid_cents
    [reported_required_fee_cents || calculated_required_fee_cents, money_tendered_cents].min
  end

  def required_paid?
    money_tendered_cents >= calculated_required_fee_cents
  end

  def overunder_cents(only_required = false)
    if only_required
      money_tendered_cents - calculated_required_fee_cents
    else
      money_tendered_cents - calculated_total_cents
    end
  end

  #########
  protected
  #########

  def compute_fee_totals
    self.reported_required_fee_cents = self.calculated_required_fee_cents
    self.reported_suggested_fee_cents = self.calculated_suggested_fee_cents
  end

  def cleanup_for_contact_type
    case contact_type
    when 'named' then
      self.postal_code = nil
    when 'anonymous' then
      self.contact_id = nil
    when 'dumped' then
      self.postal_code = self.contact_id = nil
    end
  end

  def add_dead_beat_discount
    under_pay = calculated_under_pay
    if under_pay < 0
        gizmo_events.build({:unit_price_cents => under_pay,
                                         :gizmo_count => 1,
                                         :gizmo_type => GizmoType.fee_discount,
                                         :gizmo_context => GizmoContext.donation,
                                         :covered => false})
    end
  end

  private
  def contact_valid_type
    unless is_adjustment?
      if contact_type == 'named'
        errors.add_on_empty("contact_id")
        if contact_id.to_i == 0 or !Contact.exists?(contact_id)
          errors.add("contact_id", "does not refer to any single, unique contact")
        end
      elsif contact_type == 'anonymous'
        errors.add_on_empty("postal_code")
      elsif contact_type != 'dumped'
        errors.add("contact_type",
                   "should be one of 'named', 'anonymous', or 'dumped'")
      end
    end
  end

  def bubble_gizmo_count
    unless is_adjustment?
      gizmo_events_actual.each do |gizmo|
        if not gizmo.valid_gizmo_count?
          errors.add("gizmos", "must have positive quantity")
        end
      end
    end
  end

  def includes_payment_or_gizmo
    if gizmo_events_actual.empty? and payments.empty?
      errors.add("payments",
                 "or gizmos should include some reason to call this a donation")
    end
  end

  def maximum_invoices
    errors.add("payments", "may only have one invoice") if invoices.length > 1
  end
end
