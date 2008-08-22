require File.dirname(__FILE__) + '/../test_helper'

class TransactionTotalsTest < Test::Unit::TestCase

#   fixtures :contact_types, :contact_method_types, :contacts, :payment_methods, :gizmo_contexts,
#     :gizmo_attrs, :gizmo_types, :gizmo_typeattrs,
#     :gizmo_contexts_gizmo_typeattrs, :gizmo_contexts_gizmo_types, :donations
  load_all_fixtures

  def donate_a_crt
    don = Donation.new(WITH_CONTACT_INFO)
    crt = GizmoEvent.new(crt_event)
    assert_equal 1000, crt.required_fee_cents
    don.gizmo_events = [crt]
    return don
  end

  def test_totals_with_a_single_payment
    don = donate_a_crt
    don.payments = [some_cash(1200)]
    assert don.save
    assert_equal 1000, don.reported_required_fee_cents
    totals = nil
    assert_nothing_raised { totals = Donation.totals(["donations.id = ?", don.id]) }
    assert totals
    assert_cash_amount [1000, 200], totals
  end

  def test_totals_across_multiple_cash_payments
    don = donate_a_crt
    don.payments = [some_cash(700), some_check(700), some_cash(1000)]
    assert don.save
    assert_equal 1000, don.reported_required_fee_cents
    totals = nil
    assert_nothing_raised { totals = Donation.totals(["donations.id = ?", don.id]) }
    assert totals
    assert_cash_amount [1000,700], totals
    assert_check_amount [0, 700], totals
  end

  def test_totals_across_multiple_payments
    don = donate_a_crt
    don.payments = [some_cash(700), some_check(700)]
    assert don.save
    assert_equal 1000, don.reported_required_fee_cents
    totals = nil
    assert_nothing_raised { totals = Donation.totals(["donations.id = ?", don.id]) }
    assert totals
    assert_cash_amount [700,0], totals
    assert_check_amount [300,400], totals
  end

  def assert_cash_amount(tuple, totals)
    assert_amount_by_payment_method(tuple, totals, PaymentMethod.cash)
  end

  def assert_check_amount(tuple, totals)
    assert_amount_by_payment_method(tuple, totals, PaymentMethod.check)
  end

  def assert_amount_by_payment_method(tuple, totals, method)
    required, suggested = tuple
    i = 0
    totals.each {|summations|
      i +=1
      method_id = summations['payment_method_id']
      assert_not_nil method_id
      case method_id.to_i
      when method.id
        assert_equal required, summations['amount'].to_i
        assert_equal suggested, summations['amount'].to_i - summations['required'].to_i
        assert_equal 5, 4
      end
    }
    assert i > 0, "there should be entries in the totals summations"
  end
end
