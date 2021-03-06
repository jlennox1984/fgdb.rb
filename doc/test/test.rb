#!/usr/bin/ruby

#YEAR=(ARGV[0] || 2000)
#puts "Testing year #{YEAR}"
#ORDER_AND_LIMIT="WHERE extract( year from created_at )::integer = #{YEAR} AND extract( seconds from created_at )::integer = 29 ORDER BY id DESC LIMIT 50"
#ORDER_AND_LIMIT="WHERE extract( year from created_at )::integer = #{YEAR} ORDER BY id DESC LIMIT 50"
#ORDER_AND_LIMIT="ORDER BY id DESC LIMIT 100"

ORDER_AND_LIMIT="ORDER BY id ASC"

#ORDER_AND_LIMIT="WHERE id IN (#{File.open("/home/ryan52/fgdb.rb/ids").readlines.join(", ")}) ORDER BY id ASC"

dir = File.basename(File.expand_path(File.dirname(__FILE__)))
if dir == "trunk"
  ENV['RAILS_ENV']="development"
elsif dir == "release_1.0.11"
  ENV['RAILS_ENV']="production"
else
  puts "Unknown branch: " + dir
  raise
end

require File.dirname(__FILE__) + '/config/boot'
require File.expand_path(File.dirname(__FILE__) + "/config/environment")

f = File.open("output/donations", "w")
Donation.connection.execute("SELECT id FROM donations #{ORDER_AND_LIMIT}").to_a.map{|x| x['id'].to_i}.each{|x|
  d = Donation.find_by_id(x)
  string = ""
  string += d.id.to_s + " "
  string += d.reported_total_cents.to_s + " "
  string += d.calculated_required_fee_cents.to_s + " "
  string += d.calculated_suggested_fee_cents.to_s + " "
  string += d.calculated_total_cents.to_s + " "
  string += d.cash_donation_owed_cents.to_s + " "
  string += d.cash_donation_paid_cents.to_s + " "
  string += d.required_fee_owed_cents.to_s + " "
  string += d.required_fee_paid_cents.to_s + " "
  string += d.required_paid?.to_s + " "
  string += d.invoiced?.to_s + " "
  string += d.overunder_cents(true).to_s + " "
  string += d.overunder_cents(false).to_s + " "
  f.write(string + "\n")
}
f.close

f = File.open("output/sales", "w")
Sale.connection.execute("SELECT id FROM sales #{ORDER_AND_LIMIT}").to_a.map{|x| x['id'].to_i}.each{|x|
  s = Sale.find_by_id(x)
  string = ""
  string += s.id.to_s + " "
  string += s.calculated_total_cents.to_s + " "
  string += s.calculated_subtotal_cents.to_s + " "
  string += s.calculated_discount_cents.to_s + " "
  f.write(string + "\n")
}
f.close

f = File.open("output/gizmo_events", "w")
GizmoEvent.connection.execute("SELECT id FROM gizmo_events #{ORDER_AND_LIMIT}").to_a.map{|x| x['id'].to_i}.each{|x|
  g = GizmoEvent.find_by_id(x)
  string = ""
  string += g.id.to_s + " "
  string += g.donation_id.to_s + " "
  string += g.sale_id.to_s + " "
  string += g.disbursement_id.to_s + " "
  string += g.recycling_id.to_s + " "
  begin
    string += g.unit_price_cents.to_s + " "
  rescue
    thing = nil
    if g.donation_id != nil
      if g.adjusted_fee_cents.to_i != 0
        thing = g.adjusted_fee_cents.to_i
      else
        thing = (g.gizmo_type.suggested_fee_cents.to_i + g.gizmo_type.required_fee_cents.to_i)
      end
    end
    string += thing.to_s + " "
  end
  begin
    string += g.as_is.to_s + " "
  rescue
    string += " "
  end
  begin
    string += g.description.to_s + " "
  rescue
    string += " "
  end
  begin
    string += g.size.to_s + " "
  rescue
    string += " "
  end
  f.write(string + "\n")
}
f.close
