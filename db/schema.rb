# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 8) do

  create_table "contact_method_types", :force => true do |t|
    t.column "description",  :string,   :limit => 100
    t.column "parent_id",    :integer
    t.column "lock_version", :integer,                 :default => 0, :null => false
    t.column "updated_at",   :datetime
    t.column "created_at",   :datetime
    t.column "created_by",   :integer,                 :default => 1, :null => false
    t.column "updated_by",   :integer,                 :default => 1, :null => false
  end

  create_table "contact_methods", :force => true do |t|
    t.column "contact_method_type_id", :integer
    t.column "description",            :string,   :limit => 100
    t.column "ok",                     :boolean
    t.column "contact_id",             :integer
    t.column "lock_version",           :integer,                 :default => 0, :null => false
    t.column "updated_at",             :datetime
    t.column "created_at",             :datetime
    t.column "created_by",             :integer,                 :default => 1, :null => false
    t.column "updated_by",             :integer,                 :default => 1, :null => false
  end

  add_index "contact_methods", ["contact_id"], :name => "contact_methods_contact_id_index"

  create_table "contact_types", :force => true do |t|
    t.column "description",  :string,   :limit => 100
    t.column "for_who",      :string,   :limit => 3,   :default => "any"
    t.column "lock_version", :integer,                 :default => 0,     :null => false
    t.column "updated_at",   :datetime
    t.column "created_at",   :datetime
    t.column "created_by",   :integer,                 :default => 1,     :null => false
    t.column "updated_by",   :integer,                 :default => 1,     :null => false
  end

  create_table "contact_types_contacts", :id => false, :force => true do |t|
    t.column "contact_id",      :integer, :default => 0, :null => false
    t.column "contact_type_id", :integer, :default => 0, :null => false
  end

  add_index "contact_types_contacts", ["contact_id", "contact_type_id"], :name => "contact_types_contacts_contact_id_key", :unique => true

  create_table "contacts", :force => true do |t|
    t.column "is_organization",   :boolean,                 :default => false
    t.column "sort_name",         :string,   :limit => 25
    t.column "first_name",        :string,   :limit => 25
    t.column "middle_name",       :string,   :limit => 25
    t.column "surname",           :string,   :limit => 50
    t.column "organization",      :string,   :limit => 100
    t.column "extra_address",     :string,   :limit => 52
    t.column "address",           :string,   :limit => 52
    t.column "city",              :string,   :limit => 30
    t.column "state_or_province", :string,   :limit => 15
    t.column "postal_code",       :string,   :limit => 25
    t.column "country",           :string,   :limit => 100
    t.column "notes",             :text
    t.column "lock_version",      :integer,                 :default => 0,     :null => false
    t.column "updated_at",        :datetime
    t.column "created_at",        :datetime
    t.column "created_by",        :integer,                 :default => 1,     :null => false
    t.column "updated_by",        :integer,                 :default => 1,     :null => false
  end

  create_table "defaults", :force => true do |t|
    t.column "name",         :string,   :limit => 100
    t.column "value",        :string,   :limit => 100
    t.column "lock_version", :integer,                 :default => 0, :null => false
    t.column "updated_at",   :datetime
    t.column "created_at",   :datetime
    t.column "created_by",   :integer,                 :default => 1, :null => false
    t.column "updated_by",   :integer,                 :default => 1, :null => false
  end

  create_table "disbursement_types", :force => true do |t|
    t.column "description",  :string,   :limit => 100
    t.column "lock_version", :integer,                 :default => 0, :null => false
    t.column "updated_at",   :datetime
    t.column "created_at",   :datetime
    t.column "created_by",   :integer,                 :default => 1, :null => false
    t.column "updated_by",   :integer,                 :default => 1, :null => false
  end

  create_table "disbursements", :force => true do |t|
    t.column "comments",             :text
    t.column "contact_id",           :integer,                 :null => false
    t.column "disbursement_type_id", :integer,                 :null => false
    t.column "lock_version",         :integer,  :default => 0, :null => false
    t.column "updated_at",           :datetime
    t.column "created_at",           :datetime
    t.column "created_by",           :integer,  :default => 1, :null => false
    t.column "updated_by",           :integer,  :default => 1, :null => false
    t.column "disbursed_at",         :datetime,                :null => false
  end

  add_index "disbursements", ["created_at"], :name => "dispersements_created_at_index"

  create_table "discount_schedules", :force => true do |t|
    t.column "name",         :string,   :limit => 25
    t.column "lock_version", :integer,                :default => 0, :null => false
    t.column "updated_at",   :datetime
    t.column "created_at",   :datetime
    t.column "created_by",   :integer,                :default => 1, :null => false
    t.column "updated_by",   :integer,                :default => 1, :null => false
  end

  create_table "discount_schedules_gizmo_types", :force => true do |t|
    t.column "gizmo_type_id",        :integer,                                                :null => false
    t.column "discount_schedule_id", :integer,                                                :null => false
    t.column "multiplier",           :decimal,  :precision => 10, :scale => 3
    t.column "lock_version",         :integer,                                 :default => 0, :null => false
    t.column "updated_at",           :datetime
    t.column "created_at",           :datetime
    t.column "created_by",           :integer,                                 :default => 1, :null => false
    t.column "updated_by",           :integer,                                 :default => 1, :null => false
  end

  create_table "donations", :force => true do |t|
    t.column "contact_id",             :integer
    t.column "postal_code",            :string,   :limit => 25
    t.column "reported_required_fee",  :decimal,                :precision => 10, :scale => 2, :default => 0.0
    t.column "reported_suggested_fee", :decimal,                :precision => 10, :scale => 2, :default => 0.0
    t.column "txn_complete",           :boolean,                                               :default => true
    t.column "txn_completed_at",       :datetime
    t.column "comments",               :text
    t.column "lock_version",           :integer,                                               :default => 0,    :null => false
    t.column "updated_at",             :datetime
    t.column "created_at",             :datetime
    t.column "created_by",             :integer,                                               :default => 1,    :null => false
    t.column "updated_by",             :integer,                                               :default => 1,    :null => false
  end

  add_index "donations", ["created_at"], :name => "donations_created_at_index"

  create_table "engine_schema_info", :id => false, :force => true do |t|
    t.column "engine_name", :string
    t.column "version",     :integer
  end

  create_table "gizmo_attrs", :force => true do |t|
    t.column "name",         :string,   :limit => 100
    t.column "datatype",     :string,   :limit => 10
    t.column "lock_version", :integer,                 :default => 0, :null => false
    t.column "updated_at",   :datetime
    t.column "created_at",   :datetime
    t.column "created_by",   :integer,                 :default => 1, :null => false
    t.column "updated_by",   :integer,                 :default => 1, :null => false
  end

  create_table "gizmo_contexts", :force => true do |t|
    t.column "name",         :string,   :limit => 100
    t.column "lock_version", :integer,                 :default => 0, :null => false
    t.column "updated_at",   :datetime
    t.column "created_at",   :datetime
    t.column "created_by",   :integer,                 :default => 1, :null => false
    t.column "updated_by",   :integer,                 :default => 1, :null => false
  end

  create_table "gizmo_contexts_gizmo_typeattrs", :id => false, :force => true do |t|
    t.column "gizmo_context_id",  :integer,                 :null => false
    t.column "gizmo_typeattr_id", :integer,                 :null => false
    t.column "lock_version",      :integer,  :default => 0, :null => false
    t.column "updated_at",        :datetime
    t.column "created_at",        :datetime
    t.column "created_by",        :integer,  :default => 1, :null => false
    t.column "updated_by",        :integer,  :default => 1, :null => false
  end

  create_table "gizmo_contexts_gizmo_types", :id => false, :force => true do |t|
    t.column "gizmo_context_id", :integer,                 :null => false
    t.column "gizmo_type_id",    :integer,                 :null => false
    t.column "lock_version",     :integer,  :default => 0, :null => false
    t.column "updated_at",       :datetime
    t.column "created_at",       :datetime
    t.column "created_by",       :integer,  :default => 1, :null => false
    t.column "updated_by",       :integer,  :default => 1, :null => false
  end

  create_table "gizmo_events", :force => true do |t|
    t.column "donation_id",      :integer
    t.column "sale_id",          :integer
    t.column "disbursement_id",  :integer
    t.column "recycling_id",     :integer
    t.column "gizmo_type_id",    :integer,                 :null => false
    t.column "gizmo_context_id", :integer,                 :null => false
    t.column "gizmo_count",      :integer,                 :null => false
    t.column "lock_version",     :integer,  :default => 0, :null => false
    t.column "updated_at",       :datetime
    t.column "created_at",       :datetime
    t.column "created_by",       :integer,  :default => 1, :null => false
    t.column "updated_by",       :integer,  :default => 1, :null => false
  end

  add_index "gizmo_events", ["created_at"], :name => "gizmo_events_created_at_index"
  add_index "gizmo_events", ["disbursement_id"], :name => "gizmo_events_dispersement_id_index"
  add_index "gizmo_events", ["donation_id"], :name => "gizmo_events_donation_id_index"
  add_index "gizmo_events", ["recycling_id"], :name => "gizmo_events_recycling_id_index"
  add_index "gizmo_events", ["sale_id"], :name => "gizmo_events_sale_id_index"

  create_table "gizmo_events_gizmo_typeattrs", :force => true do |t|
    t.column "gizmo_event_id",    :integer,                                                :null => false
    t.column "gizmo_typeattr_id", :integer,                                                :null => false
    t.column "attr_val_text",     :text
    t.column "attr_val_boolean",  :boolean
    t.column "attr_val_integer",  :integer
    t.column "attr_val_monetary", :decimal,  :precision => 10, :scale => 2
    t.column "lock_version",      :integer,                                 :default => 0, :null => false
    t.column "updated_at",        :datetime
    t.column "created_at",        :datetime
    t.column "created_by",        :integer,                                 :default => 1, :null => false
    t.column "updated_by",        :integer,                                 :default => 1, :null => false
  end

  create_table "gizmo_typeattrs", :force => true do |t|
    t.column "gizmo_type_id",       :integer,                    :null => false
    t.column "gizmo_attr_id",       :integer,                    :null => false
    t.column "is_required",         :boolean,  :default => true, :null => false
    t.column "validation_callback", :text
    t.column "lock_version",        :integer,  :default => 0,    :null => false
    t.column "updated_at",          :datetime
    t.column "created_at",          :datetime
    t.column "created_by",          :integer,  :default => 1,    :null => false
    t.column "updated_by",          :integer,  :default => 1,    :null => false
  end

  create_table "gizmo_types", :force => true do |t|
    t.column "description",   :string,   :limit => 100
    t.column "parent_id",     :integer
    t.column "lock_version",  :integer,                                                :default => 0,   :null => false
    t.column "updated_at",    :datetime
    t.column "created_at",    :datetime
    t.column "created_by",    :integer,                                                :default => 1,   :null => false
    t.column "updated_by",    :integer,                                                :default => 1,   :null => false
    t.column "required_fee",  :decimal,                 :precision => 10, :scale => 2, :default => 0.0
    t.column "suggested_fee", :decimal,                 :precision => 10, :scale => 2, :default => 0.0
  end

  create_table "payment_methods", :force => true do |t|
    t.column "description",  :string,   :limit => 100
    t.column "lock_version", :integer,                 :default => 0, :null => false
    t.column "updated_at",   :datetime
    t.column "created_at",   :datetime
    t.column "created_by",   :integer,                 :default => 1, :null => false
    t.column "updated_by",   :integer,                 :default => 1, :null => false
  end

  create_table "payments", :force => true do |t|
    t.column "donation_id",       :integer
    t.column "sale_id",           :integer
    t.column "amount",            :decimal,  :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.column "payment_method_id", :integer,                                                  :null => false
    t.column "lock_version",      :integer,                                 :default => 0,   :null => false
    t.column "updated_at",        :datetime
    t.column "created_at",        :datetime
    t.column "created_by",        :integer,                                 :default => 1,   :null => false
    t.column "updated_by",        :integer,                                 :default => 1,   :null => false
  end

  add_index "payments", ["donation_id"], :name => "payments_donation_id_index"
  add_index "payments", ["donation_id"], :name => "payments_donations_id"
  add_index "payments", ["sale_id"], :name => "payments_sale_id"
  add_index "payments", ["sale_id"], :name => "payments_sale_id_index"

  create_table "recyclings", :force => true do |t|
    t.column "comments",     :text
    t.column "lock_version", :integer,  :default => 0, :null => false
    t.column "updated_at",   :datetime
    t.column "created_at",   :datetime
    t.column "created_by",   :integer,  :default => 1, :null => false
    t.column "updated_by",   :integer,  :default => 1, :null => false
    t.column "recycled_at",  :datetime,                :null => false
  end

  add_index "recyclings", ["created_at"], :name => "recyclings_created_at_index"

  create_table "rfs_high_sales", :id => false, :force => true do |t|
    t.column "contact_id",               :integer
    t.column "reported_discount_amount", :decimal,               :precision => 10, :scale => 2
    t.column "open_window",              :date
    t.column "close_window",             :date
    t.column "first_name",               :string,  :limit => 25
    t.column "surname",                  :string,  :limit => 50
    t.column "hours_worked",             :decimal
    t.column "discount_taken",           :decimal
  end

  add_index "rfs_high_sales", ["contact_id"], :name => "rfs_high_sales_contact_id"
  add_index "rfs_high_sales", ["reported_discount_amount"], :name => "rfs_high_sales_reported_discount_amount"

  create_table "rfs_high_sales_summary", :id => false, :force => true do |t|
    t.column "contact_id", :integer
    t.column "discounted", :decimal
  end

  create_table "rfs_sales_violations", :id => false, :force => true do |t|
    t.column "contact_id",               :integer
    t.column "reported_discount_amount", :decimal,               :precision => 10, :scale => 2
    t.column "open_window",              :date
    t.column "close_window",             :date
    t.column "first_name",               :string,  :limit => 25
    t.column "surname",                  :string,  :limit => 50
    t.column "hours_worked",             :decimal
    t.column "discount_taken",           :decimal
  end

  create_table "rfs_sales_violations_summary", :id => false, :force => true do |t|
    t.column "contact_id",        :integer
    t.column "first_name",        :string,  :limit => 25
    t.column "surname",           :string,  :limit => 50
    t.column "violation_summary", :decimal
    t.column "discount_taken",    :decimal
    t.column "hours_worked",      :decimal
    t.column "rate",              :decimal
    t.column "open_window",       :date
    t.column "close_window",      :date
  end

  create_table "rfs_total_discount_taken", :id => false, :force => true do |t|
    t.column "contact_id",     :integer
    t.column "discount_taken", :decimal
  end

  create_table "rfs_volunteer_hours_worked", :id => false, :force => true do |t|
    t.column "contact_id",   :integer
    t.column "hours_worked", :decimal
  end

  create_table "sales", :force => true do |t|
    t.column "contact_id",               :integer
    t.column "postal_code",              :string,   :limit => 25
    t.column "reported_discount_amount", :decimal,                :precision => 10, :scale => 2, :default => 0.0
    t.column "reported_amount_due",      :decimal,                :precision => 10, :scale => 2, :default => 0.0,  :null => false
    t.column "txn_complete",             :boolean,                                               :default => true
    t.column "txn_completed_at",         :datetime
    t.column "discount_schedule_id",     :integer
    t.column "comments",                 :text
    t.column "bulk",                     :boolean
    t.column "lock_version",             :integer,                                               :default => 0,    :null => false
    t.column "updated_at",               :datetime
    t.column "created_at",               :datetime
    t.column "created_by",               :integer,                                               :default => 1,    :null => false
    t.column "updated_by",               :integer,                                               :default => 1,    :null => false
  end

  add_index "sales", ["contact_id"], :name => "sales_contact_id"
  add_index "sales", ["created_at"], :name => "sales_created_at_index"
  add_index "sales", ["reported_discount_amount"], :name => "sales_reported_discount_amount"

  create_table "volunteer_hours_worked", :id => false, :force => true do |t|
    t.column "contact_id",   :integer
    t.column "hours_worked", :decimal
  end

  create_table "volunteer_task_types", :force => true do |t|
    t.column "description",      :string,   :limit => 100
    t.column "parent_id",        :integer
    t.column "hours_multiplier", :decimal,                 :precision => 10, :scale => 3, :default => 1.0,  :null => false
    t.column "instantiable",     :boolean,                                                :default => true, :null => false
    t.column "lock_version",     :integer,                                                :default => 0,    :null => false
    t.column "updated_at",       :datetime
    t.column "created_at",       :datetime
    t.column "created_by",       :integer,                                                :default => 1,    :null => false
    t.column "updated_by",       :integer,                                                :default => 1,    :null => false
    t.column "required",         :boolean,                                                :default => true, :null => false
  end

  create_table "volunteer_task_types_volunteer_tasks", :id => false, :force => true do |t|
    t.column "volunteer_task_id",      :integer, :null => false
    t.column "volunteer_task_type_id", :integer, :null => false
  end

  add_index "volunteer_task_types_volunteer_tasks", ["volunteer_task_id"], :name => "volunteer_task_types_volunteer_tasks_volunteer_task_id_index"

  create_table "volunteer_tasks", :force => true do |t|
    t.column "contact_id",     :integer
    t.column "duration",       :decimal,  :precision => 5, :scale => 2, :default => 0.0, :null => false
    t.column "lock_version",   :integer,                                :default => 0,   :null => false
    t.column "updated_at",     :datetime
    t.column "created_at",     :datetime
    t.column "created_by",     :integer,                                :default => 1,   :null => false
    t.column "updated_by",     :integer,                                :default => 1,   :null => false
    t.column "date_performed", :date
  end

  add_index "volunteer_tasks", ["contact_id"], :name => "volunteer_tasks_contact_id_index"

  add_foreign_key "contact_methods", ["contact_id"], "contacts", ["id"], :on_delete => :set_null, :name => "contact_methods_fk_contact_id"
  add_foreign_key "contact_methods", ["contact_method_type_id"], "contact_method_types", ["id"], :on_delete => :set_null, :name => "contact_methods_fk_contact_method_type"

  add_foreign_key "disbursements", ["contact_id"], "contacts", ["id"], :on_update => :cascade, :on_delete => :set_null, :name => "dispersements_contact_id_fkey"
  add_foreign_key "disbursements", ["disbursement_type_id"], "disbursement_types", ["id"], :on_update => :cascade, :on_delete => :set_null, :name => "dispersements_dispersement_type_id_fkey"

  add_foreign_key "payments", ["donation_id"], "donations", ["id"], :name => "payments_donation_id_fkey"
  add_foreign_key "payments", ["sale_id"], "sales", ["id"], :name => "payments_sale_txn_id_fkey"

  create_view "v_donation_totals", "SELECT d.id, sum(p.amount) AS total_paid FROM (donations d LEFT JOIN payments p ON ((p.donation_id = d.id))) GROUP BY d.id;", :force => true do |v|
    v.column :id
    v.column :total_paid
  end

  create_view "v_donations", "SELECT d.id, d.contact_id, d.postal_code, d.reported_required_fee, d.reported_suggested_fee, d.txn_complete, d.txn_completed_at, d.comments, d.lock_version, d.updated_at, d.created_at, d.created_by, d.updated_by, v.total_paid, CASE WHEN (v.total_paid > d.reported_required_fee) THEN d.reported_required_fee ELSE v.total_paid END AS fees_paid, CASE WHEN (v.total_paid < d.reported_required_fee) THEN 0.00 ELSE (v.total_paid - d.reported_required_fee) END AS donations_paid FROM (donations d JOIN v_donation_totals v ON ((d.id = v.id)));", :force => true do |v|
    v.column :id
    v.column :contact_id
    v.column :postal_code
    v.column :reported_required_fee
    v.column :reported_suggested_fee
    v.column :txn_complete
    v.column :txn_completed_at
    v.column :comments
    v.column :lock_version
    v.column :updated_at
    v.column :created_at
    v.column :created_by
    v.column :updated_by
    v.column :total_paid
    v.column :fees_paid
    v.column :donations_paid
  end

end
