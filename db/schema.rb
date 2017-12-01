# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160907021959) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "addresses", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "country"
    t.string   "postcode",       limit: 10
    t.string   "state"
    t.string   "suburb"
    t.string   "street_address"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["user_id"], name: "index_addresses_on_user_id", using: :btree
  end

  create_table "appointment_products", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "appointment_setting_id"
    t.integer  "doctor_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["appointment_setting_id"], name: "index_appointment_products_on_appointment_setting_id", using: :btree
    t.index ["doctor_id"], name: "index_appointment_products_on_doctor_id", using: :btree
  end

  create_table "appointment_settings", force: :cascade do |t|
    t.string   "start_time", limit: 10
    t.string   "end_time",   limit: 10
    t.integer  "user_id"
    t.decimal  "price"
    t.string   "week_day"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["user_id"], name: "index_appointment_settings_on_user_id", using: :btree
  end

  create_table "appointments", force: :cascade do |t|
    t.integer  "doctor_id"
    t.integer  "patient_id"
    t.integer  "status",                 default: 1
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "appointment_product_id"
    t.decimal  "consultation_fee"
    t.decimal  "doctor_fee"
    t.string   "job_id"
    t.index ["doctor_id"], name: "index_appointments_on_doctor_id", using: :btree
    t.index ["patient_id"], name: "index_appointments_on_patient_id", using: :btree
  end

  create_table "auth_tokens", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "expired_at"
    t.index ["user_id"], name: "index_auth_tokens_on_user_id", using: :btree
  end

  create_table "authorizations", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.string   "secret"
    t.string   "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_authorizations_on_user_id", using: :btree
  end

  create_table "bank_accounts", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "account_id"
    t.string   "country",             limit: 10
    t.string   "currency",            limit: 10, default: "aud"
    t.string   "account_holder_name"
    t.string   "account_holder_type"
    t.string   "bank_name"
    t.string   "last4",               limit: 4
    t.string   "routing_number"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.index ["user_id"], name: "index_bank_accounts_on_user_id", using: :btree
  end

  create_table "charge_event_logs", force: :cascade do |t|
    t.string   "stripe_customer_id"
    t.decimal  "amount"
    t.string   "currency"
    t.string   "card_last4"
    t.string   "card_brand"
    t.string   "stripe_charge_id"
    t.integer  "status"
    t.integer  "checkout_id"
    t.integer  "charge_event_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "charge_events", force: :cascade do |t|
    t.integer  "appointment_id"
    t.integer  "status",         default: 0
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["appointment_id"], name: "index_charge_events_on_appointment_id", using: :btree
  end

  create_table "checkouts", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "address"
    t.string   "country"
    t.string   "email"
    t.string   "stripe_customer_id", limit: 50
    t.string   "card_last4",         limit: 4
    t.string   "brand",              limit: 20
    t.boolean  "default",                       default: false
    t.string   "funding",            limit: 10
    t.integer  "exp_month"
    t.integer  "exp_year"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.index ["user_id"], name: "index_checkouts_on_user_id", using: :btree
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "appointment_id"
    t.integer  "receiver_id"
    t.integer  "sender_id"
    t.text     "body"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["appointment_id"], name: "index_comments_on_appointment_id", using: :btree
  end

  create_table "conferences", force: :cascade do |t|
    t.integer  "appointment_id"
    t.integer  "status",         default: 1
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "twillo_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["appointment_id"], name: "index_conferences_on_appointment_id", using: :btree
  end

  create_table "devices", force: :cascade do |t|
    t.integer  "platform"
    t.string   "token"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["platform", "token"], name: "index_devices_on_platform_and_token", unique: true, using: :btree
    t.index ["user_id"], name: "index_devices_on_user_id", using: :btree
  end

  create_table "doctor_profiles", force: :cascade do |t|
    t.integer  "user_id"
    t.decimal  "years_experience"
    t.text     "bio_info"
    t.boolean  "approved",         default: false
    t.boolean  "available",        default: false
    t.string   "provider_number"
    t.integer  "specialty_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.index ["user_id"], name: "index_doctor_profiles_on_user_id", using: :btree
  end

  create_table "fcm_messages", force: :cascade do |t|
    t.integer "status",              default: 0
    t.integer "receiver_id"
    t.string  "tokens",                          array: true
    t.json    "notification"
    t.json    "data"
    t.json    "raw_resp"
    t.string  "ex"
    t.string  "ex_message"
    t.integer "success_count",       default: 0
    t.integer "failure_count",       default: 0
    t.integer "web_notification_id"
    t.index ["receiver_id"], name: "index_fcm_messages_on_receiver_id", using: :btree
    t.index ["web_notification_id"], name: "index_fcm_messages_on_web_notification_id", using: :btree
  end

  create_table "medical_certificates", force: :cascade do |t|
    t.integer  "appointment_id"
    t.string   "file"
    t.boolean  "deleted",        default: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["appointment_id"], name: "index_medical_certificates_on_appointment_id", using: :btree
  end

  create_table "notifications", force: :cascade do |t|
    t.string   "n_type"
    t.integer  "user_id"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.boolean  "is_read",       default: false
    t.text     "body"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["resource_id"], name: "index_notifications_on_resource_id", using: :btree
    t.index ["user_id"], name: "index_notifications_on_user_id", using: :btree
  end

  create_table "patient_profiles", force: :cascade do |t|
    t.integer  "sex",        default: 0
    t.date     "birthday"
    t.integer  "user_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["user_id"], name: "index_patient_profiles_on_user_id", using: :btree
  end

  create_table "pharmacies", force: :cascade do |t|
    t.string   "category"
    t.string   "company_name"
    t.string   "street"
    t.string   "suburb"
    t.string   "state"
    t.integer  "code"
    t.string   "country"
    t.string   "phone"
    t.string   "website"
    t.string   "mobile"
    t.string   "toll_free"
    t.string   "fax"
    t.string   "abn"
    t.string   "postal_address"
    t.string   "email"
    t.string   "latitude"
    t.string   "longitude"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "prescriptions", force: :cascade do |t|
    t.integer  "appointment_id"
    t.integer  "pharmacy_id"
    t.string   "file"
    t.integer  "status"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "deleted",        default: false
    t.index ["appointment_id"], name: "index_prescriptions_on_appointment_id", using: :btree
    t.index ["pharmacy_id"], name: "index_prescriptions_on_pharmacy_id", using: :btree
  end

  create_table "refund_requests", force: :cascade do |t|
    t.integer  "appointment_id"
    t.integer  "status",                default: 0
    t.integer  "charge_event_log_id"
    t.integer  "transfer_event_log_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "reason"
    t.index ["appointment_id"], name: "index_refund_requests_on_appointment_id", using: :btree
    t.index ["charge_event_log_id"], name: "index_refund_requests_on_charge_event_log_id", using: :btree
    t.index ["transfer_event_log_id"], name: "index_refund_requests_on_transfer_event_log_id", using: :btree
  end

  create_table "specialties", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "surveys", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "appointment_id"
    t.string   "full_name"
    t.string   "suburb"
    t.integer  "age"
    t.integer  "gender",            default: 0
    t.string   "street_address"
    t.integer  "weight"
    t.integer  "height"
    t.string   "occupation"
    t.text     "medical_condition"
    t.text     "medications"
    t.integer  "reason_id"
    t.string   "allergies"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["appointment_id"], name: "index_surveys_on_appointment_id", using: :btree
    t.index ["user_id"], name: "index_surveys_on_user_id", using: :btree
  end

  create_table "transfer_event_logs", force: :cascade do |t|
    t.string   "stripe_transfer_id"
    t.integer  "transfer_event_id"
    t.string   "currency"
    t.decimal  "amount"
    t.integer  "status"
    t.string   "destination"
    t.text     "error_message"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "transfer_events", force: :cascade do |t|
    t.integer  "appointment_id"
    t.integer  "status",         default: 0
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["appointment_id"], name: "index_transfer_events_on_appointment_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                             default: "",                 null: false
    t.string   "encrypted_password",                default: "",                 null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0,                  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                                                     null: false
    t.datetime "updated_at",                                                     null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address"
    t.string   "phone"
    t.string   "type"
    t.string   "image"
    t.boolean  "notify_sms",                        default: true
    t.boolean  "notify_email",                      default: true
    t.boolean  "notify_system",                     default: true
    t.string   "username",               limit: 30
    t.string   "local_timezone",                    default: "Australia/Sydney"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "addresses", "users"
  add_foreign_key "appointment_products", "appointment_settings"
  add_foreign_key "authorizations", "users"
  add_foreign_key "bank_accounts", "users"
  add_foreign_key "charge_events", "appointments"
  add_foreign_key "checkouts", "users"
  add_foreign_key "comments", "appointments"
  add_foreign_key "conferences", "appointments"
  add_foreign_key "devices", "users"
  add_foreign_key "doctor_profiles", "users"
  add_foreign_key "medical_certificates", "appointments"
  add_foreign_key "notifications", "users"
  add_foreign_key "patient_profiles", "users"
  add_foreign_key "refund_requests", "appointments"
  add_foreign_key "refund_requests", "charge_event_logs"
  add_foreign_key "refund_requests", "transfer_event_logs"
  add_foreign_key "surveys", "appointments"
  add_foreign_key "surveys", "users"
  add_foreign_key "transfer_events", "appointments"
end
