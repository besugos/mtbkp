# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_03_09_171712) do

  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "blob_id", null: false
    t.string "variation_digest", null: false
    t.bigint "active_storage_blobs"
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "address_areas", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "address_types", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "addresses", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "ownertable_type"
    t.bigint "ownertable_id"
    t.string "name"
    t.string "zipcode"
    t.string "address"
    t.string "district"
    t.string "number"
    t.string "complement"
    t.text "reference"
    t.bigint "address_area_id"
    t.bigint "address_type_id"
    t.bigint "state_id"
    t.bigint "city_id"
    t.bigint "country_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "latitude"
    t.string "longitude"
    t.index ["address_area_id"], name: "index_addresses_on_address_area_id"
    t.index ["address_type_id"], name: "index_addresses_on_address_type_id"
    t.index ["city_id"], name: "index_addresses_on_city_id"
    t.index ["country_id"], name: "index_addresses_on_country_id"
    t.index ["ownertable_type", "ownertable_id"], name: "index_addresses_on_ownertable"
    t.index ["state_id"], name: "index_addresses_on_state_id"
  end

  create_table "api_keys", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "access_token"
    t.integer "user_id"
    t.boolean "active"
    t.datetime "expires_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["access_token"], name: "index_api_keys_on_access_token", unique: true
    t.index ["user_id"], name: "index_api_keys_on_user_id"
  end

  create_table "attachments", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "ownertable_type"
    t.bigint "ownertable_id"
    t.integer "attachment_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ownertable_type", "ownertable_id"], name: "index_attachments_on_ownertable"
  end

  create_table "audits", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.text "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_id", "associated_type"], name: "associated_index"
    t.index ["auditable_id", "auditable_type"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "banks", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "number"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "banner_areas", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "banners", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "banner_area_id"
    t.string "link"
    t.string "title"
    t.integer "position"
    t.boolean "active", default: true
    t.date "disponible_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["banner_area_id"], name: "index_banners_on_banner_area_id"
  end

  create_table "cancel_order_reasons", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cancel_orders", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "freight_order_id"
    t.bigint "cancel_order_reason_id"
    t.text "reason_text", size: :medium
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["cancel_order_reason_id"], name: "index_cancel_orders_on_cancel_order_reason_id"
    t.index ["freight_order_id"], name: "index_cancel_orders_on_freight_order_id"
    t.index ["order_id"], name: "index_cancel_orders_on_order_id"
  end

  create_table "card_banners", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cards", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "ownertable_type"
    t.bigint "ownertable_id"
    t.bigint "card_banner_id"
    t.string "nickname"
    t.string "encrypted_name"
    t.string "encrypted_name_iv"
    t.string "encrypted_number"
    t.string "encrypted_number_iv"
    t.string "encrypted_ccv_code"
    t.string "encrypted_ccv_code_iv"
    t.string "validate_date_month"
    t.string "validate_date_year"
    t.boolean "principal", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["card_banner_id"], name: "index_cards_on_card_banner_id"
    t.index ["ownertable_type", "ownertable_id"], name: "index_cards_on_ownertable"
  end

  create_table "categories", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "category_type_id"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_type_id"], name: "index_categories_on_category_type_id"
  end

  create_table "category_types", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cities", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "latitude"
    t.string "longitude"
    t.string "ibge_code"
    t.decimal "quantity_population", precision: 10
    t.bigint "state_id"
    t.bigint "country_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["country_id"], name: "index_cities_on_country_id"
    t.index ["state_id"], name: "index_cities_on_state_id"
  end

  create_table "civil_states", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "ckeditor_assets", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "data_file_name", null: false
    t.string "data_content_type"
    t.integer "data_file_size"
    t.string "data_fingerprint"
    t.string "type", limit: 30
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["type"], name: "index_ckeditor_assets_on_type"
  end

  create_table "countries", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "coupon_areas", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "coupon_types", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "data_bank_types", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "data_banks", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "ownertable_type"
    t.bigint "ownertable_id"
    t.bigint "bank_id"
    t.bigint "data_bank_type_id"
    t.string "bank_number"
    t.string "agency"
    t.string "account"
    t.string "operation"
    t.string "assignor"
    t.string "cpf_cnpj"
    t.string "pix"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["bank_id"], name: "index_data_banks_on_bank_id"
    t.index ["data_bank_type_id"], name: "index_data_banks_on_data_bank_type_id"
    t.index ["ownertable_type", "ownertable_id"], name: "index_data_banks_on_ownertable"
  end

  create_table "data_professionals", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "professional_document_status_id"
    t.string "email"
    t.string "phone"
    t.string "site"
    t.string "profession"
    t.string "register_type"
    t.string "register_number"
    t.text "repprovation_reason"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "quantity_products_to_register", default: 0
    t.integer "quantity_products_active", default: 0
    t.integer "quantity_products_left", default: 0
    t.integer "quantity_services_to_register", default: 0
    t.integer "quantity_services_active", default: 0
    t.integer "quantity_services_left", default: 0
    t.bigint "product_plan_id"
    t.bigint "service_plan_id"
    t.index ["product_plan_id"], name: "index_data_professionals_on_product_plan_id"
    t.index ["professional_document_status_id"], name: "index_data_professionals_on_professional_document_status_id"
    t.index ["service_plan_id"], name: "index_data_professionals_on_service_plan_id"
    t.index ["user_id"], name: "index_data_professionals_on_user_id"
  end

  create_table "data_professionals_specialties", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "data_professional_id"
    t.bigint "specialty_id"
    t.index ["data_professional_id"], name: "fk_rails_f619bdba1d"
    t.index ["specialty_id"], name: "fk_rails_c4ee6e4d8f"
  end

  create_table "distance_service_historics", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "lat_origin"
    t.string "lng_origin"
    t.string "lat_destination"
    t.string "lng_destination"
    t.text "destination_address"
    t.text "origin_address"
    t.text "distance_text"
    t.text "duration_text"
    t.decimal "distance_value", precision: 15, scale: 4
    t.decimal "duration_value", precision: 15, scale: 4
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "email_types", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "emails", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "ownertable_type"
    t.bigint "ownertable_id"
    t.string "email"
    t.bigint "email_type_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email_type_id"], name: "index_emails_on_email_type_id"
    t.index ["ownertable_type", "ownertable_id"], name: "index_emails_on_ownertable"
  end

  create_table "freight_companies", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.integer "melhor_envio_id"
    t.text "picture_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "freight_order_options", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "freight_order_id"
    t.string "name"
    t.decimal "price", precision: 10
    t.integer "delivery_time"
    t.bigint "freight_company_id"
    t.boolean "selected", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "tracking_code"
    t.bigint "freight_order_status_id"
    t.integer "melhor_envio_service_id"
    t.text "melhor_envio_complete_data", size: :long
    t.text "melhor_envio_order_data", size: :long
    t.text "melhor_envio_checkout_data", size: :long
    t.index ["freight_company_id"], name: "index_freight_order_options_on_freight_company_id"
    t.index ["freight_order_id"], name: "index_freight_order_options_on_freight_order_id"
    t.index ["freight_order_status_id"], name: "index_freight_order_options_on_freight_order_status_id"
  end

  create_table "freight_order_statuses", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "freight_orders", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "seller_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "limit_cancel_order"
    t.index ["order_id"], name: "index_freight_orders_on_order_id"
    t.index ["seller_id"], name: "index_freight_orders_on_seller_id"
  end

  create_table "icms_contributions", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "messages", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "sender_id"
    t.bigint "receiver_id"
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "order_id"
    t.bigint "admin_id"
    t.index ["admin_id"], name: "index_messages_on_admin_id"
    t.index ["order_id"], name: "index_messages_on_order_id"
    t.index ["receiver_id"], name: "index_messages_on_receiver_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  create_table "newsletters", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.boolean "active", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "order_carts", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "order_id"
    t.string "ownertable_type"
    t.bigint "ownertable_id"
    t.integer "quantity"
    t.decimal "unity_price", precision: 15, scale: 2, default: "0.0"
    t.decimal "total_value", precision: 15, scale: 2, default: "0.0"
    t.decimal "freight_value", precision: 15, scale: 2, default: "0.0"
    t.decimal "freight_value_total", precision: 15, scale: 2, default: "0.0"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "seller_coupon_id"
    t.decimal "discount_coupon_value", precision: 15, scale: 2
    t.string "discount_coupon_text"
    t.index ["order_id"], name: "index_order_carts_on_order_id"
    t.index ["ownertable_type", "ownertable_id"], name: "index_order_carts_on_ownertable"
    t.index ["seller_coupon_id"], name: "index_order_carts_on_seller_coupon_id"
  end

  create_table "order_statuses", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "order_type_recurrents", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "orders", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "order_status_id"
    t.bigint "user_id"
    t.bigint "payment_type_id"
    t.integer "installments", default: 1
    t.decimal "price", precision: 15, scale: 2, default: "0.0"
    t.decimal "total_value", precision: 15, scale: 2, default: "0.0"
    t.decimal "total_freight_value", precision: 15, scale: 2, default: "0.0"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "seller_coupon_id"
    t.decimal "discount_by_seller_coupon", precision: 15, scale: 2
    t.string "zipcode_delivery"
    t.bigint "order_type_recurrent_id"
    t.index ["order_status_id"], name: "index_orders_on_order_status_id"
    t.index ["order_type_recurrent_id"], name: "index_orders_on_order_type_recurrent_id"
    t.index ["payment_type_id"], name: "index_orders_on_payment_type_id"
    t.index ["seller_coupon_id"], name: "index_orders_on_seller_coupon_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "payment_statuses", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "payment_transactions", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "ownertable_type"
    t.bigint "ownertable_id"
    t.decimal "value", precision: 15, scale: 2
    t.text "payment_message", size: :long
    t.string "payment_code"
    t.string "invoice_id"
    t.string "invoice_barcode"
    t.string "invoice_barcode_formatted"
    t.date "due_date"
    t.string "pdf_link"
    t.string "png_link"
    t.bigint "payment_status_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "pix_order_id"
    t.text "pix_text"
    t.text "pix_qrcode_link"
    t.datetime "pix_limit_payment_date"
    t.index ["ownertable_type", "ownertable_id"], name: "index_payment_transactions_on_ownertable"
    t.index ["payment_status_id"], name: "index_payment_transactions_on_payment_status_id"
  end

  create_table "payment_types", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "person_types", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "phone_types", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "phones", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "ownertable_type"
    t.bigint "ownertable_id"
    t.string "phone_code"
    t.string "phone"
    t.string "responsible"
    t.bigint "phone_type_id"
    t.boolean "is_whatsapp"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ownertable_type", "ownertable_id"], name: "index_phones_on_ownertable"
    t.index ["phone_type_id"], name: "index_phones_on_phone_type_id"
  end

  create_table "plan_periodicities", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.integer "months"
    t.integer "days"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "plan_services", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "plan_id"
    t.text "title"
    t.boolean "show", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["plan_id"], name: "index_plan_services_on_plan_id"
  end

  create_table "plan_types", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "plans", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "category_id"
    t.bigint "sub_category_id"
    t.bigint "plan_periodicity_id"
    t.string "name"
    t.decimal "price", precision: 15, scale: 2
    t.decimal "old_price", precision: 15, scale: 2
    t.boolean "active", default: true
    t.text "description", size: :long
    t.text "observations", size: :long
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "plan_type_id"
    t.integer "limit_products", default: 0
    t.integer "limit_service_categories", default: 0
    t.index ["category_id"], name: "index_plans_on_category_id"
    t.index ["plan_periodicity_id"], name: "index_plans_on_plan_periodicity_id"
    t.index ["plan_type_id"], name: "index_plans_on_plan_type_id"
    t.index ["sub_category_id"], name: "index_plans_on_sub_category_id"
  end

  create_table "product_conditions", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "products", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "category_id"
    t.bigint "sub_category_id"
    t.bigint "user_id"
    t.bigint "product_condition_id"
    t.string "title"
    t.decimal "price", precision: 15, scale: 2
    t.text "description"
    t.integer "quantity_stock"
    t.decimal "promotional_price", precision: 15, scale: 2
    t.decimal "avaliation_value", precision: 4, scale: 2, default: "0.0"
    t.string "width"
    t.string "height"
    t.string "depth"
    t.string "weight"
    t.bigint "selected_address_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["product_condition_id"], name: "index_products_on_product_condition_id"
    t.index ["selected_address_id"], name: "index_products_on_selected_address_id"
    t.index ["sub_category_id"], name: "index_products_on_sub_category_id"
    t.index ["user_id"], name: "index_products_on_user_id"
  end

  create_table "professional_avaliations", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "professional_id"
    t.bigint "client_id"
    t.bigint "order_id"
    t.integer "deadline_avaliation", default: 0
    t.integer "quality_avaliation", default: 0
    t.integer "problems_solution_avaliation", default: 0
    t.text "comment"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["client_id"], name: "index_professional_avaliations_on_client_id"
    t.index ["order_id"], name: "index_professional_avaliations_on_order_id"
    t.index ["professional_id"], name: "index_professional_avaliations_on_professional_id"
  end

  create_table "professional_document_statuses", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "profiles", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "radius_services", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "read_marks", charset: "latin1", force: :cascade do |t|
    t.string "readable_type", null: false
    t.integer "readable_id"
    t.string "reader_type", null: false
    t.integer "reader_id"
    t.datetime "timestamp", null: false
    t.index ["readable_type", "readable_id"], name: "index_read_marks_on_readable_type_and_readable_id"
    t.index ["reader_id", "reader_type", "readable_type", "readable_id"], name: "read_marks_reader_readable_index", unique: true
    t.index ["reader_type", "reader_id"], name: "index_read_marks_on_reader_type_and_reader_id"
  end

  create_table "rooms", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "first_participant_id"
    t.bigint "second_participant_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["first_participant_id"], name: "index_rooms_on_first_participant_id"
    t.index ["second_participant_id"], name: "index_rooms_on_second_participant_id"
  end

  create_table "seller_coupons", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "coupon_type_id"
    t.bigint "coupon_area_id"
    t.string "name"
    t.integer "quantity"
    t.date "validate_date"
    t.decimal "value", precision: 15, scale: 2
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "quantity_months", default: 1
    t.index ["coupon_area_id"], name: "index_seller_coupons_on_coupon_area_id"
    t.index ["coupon_type_id"], name: "index_seller_coupons_on_coupon_type_id"
  end

  create_table "seller_coupons_users", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "seller_coupon_id"
    t.bigint "user_id"
    t.index ["seller_coupon_id"], name: "fk_rails_b022e199b6"
    t.index ["user_id"], name: "fk_rails_7b34ef33c9"
  end

  create_table "service_goals", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "service_goals_services", id: false, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "service_id", null: false
    t.bigint "service_goal_id", null: false
  end

  create_table "service_ground_types", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "service_ground_types_services", id: false, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "service_id", null: false
    t.bigint "service_ground_type_id", null: false
  end

  create_table "service_grounds", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "service_grounds_services", id: false, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "service_id", null: false
    t.bigint "service_ground_id", null: false
  end

  create_table "services", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "category_id"
    t.bigint "sub_category_id"
    t.bigint "user_id"
    t.bigint "radius_service_id"
    t.string "name"
    t.decimal "price", precision: 15, scale: 2
    t.text "tags"
    t.boolean "active"
    t.text "description"
    t.decimal "avaliation_value", precision: 4, scale: 2, default: "0.0"
    t.bigint "selected_address_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "activate_budget", default: false
    t.string "budget_whatsapp"
    t.index ["category_id"], name: "index_services_on_category_id"
    t.index ["radius_service_id"], name: "index_services_on_radius_service_id"
    t.index ["selected_address_id"], name: "index_services_on_selected_address_id"
    t.index ["sub_category_id"], name: "index_services_on_sub_category_id"
    t.index ["user_id"], name: "index_services_on_user_id"
  end

  create_table "sexes", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "site_contact_subjects", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "site_contacts", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "site_contact_subject_id"
    t.string "name"
    t.string "email"
    t.string "phone"
    t.text "message", size: :long
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["site_contact_subject_id"], name: "index_site_contacts_on_site_contact_subject_id"
    t.index ["user_id"], name: "index_site_contacts_on_user_id"
  end

  create_table "specialties", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "states", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "acronym"
    t.string "ibge_code"
    t.bigint "country_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["country_id"], name: "index_states_on_country_id"
  end

  create_table "sub_categories", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.bigint "category_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_sub_categories_on_category_id"
  end

  create_table "system_configurations", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "notification_mail"
    t.string "contact_mail"
    t.text "use_policy", size: :long
    t.text "exchange_policy", size: :long
    t.text "warranty_policy", size: :long
    t.text "privacy_policy", size: :long
    t.string "phone"
    t.string "cellphone"
    t.string "cnpj"
    t.text "data_security_policy", size: :long
    t.text "quality", size: :long
    t.text "about", size: :long
    t.text "mission", size: :long
    t.text "view", size: :long
    t.text "values", size: :long
    t.text "linkedin_link"
    t.string "site_link"
    t.text "facebook_link"
    t.text "instagram_link"
    t.text "twitter_link"
    t.text "youtube_link"
    t.string "id_google_analytics"
    t.string "page_title"
    t.string "page_description"
    t.text "geral_conditions", size: :long
    t.text "contract_data", size: :long
    t.text "attendance_data", size: :long
    t.string "about_video_link"
    t.decimal "percent_order_products", precision: 15, scale: 2, default: "0.0"
    t.integer "maximum_installments", default: 1
    t.integer "maximum_installment_plans", default: 1
    t.string "plan_name"
    t.string "plan_price"
    t.string "plan_description"
    t.string "professional_contact_phone"
    t.string "client_contact_phone"
    t.string "professional_contact_mail"
    t.string "client_contact_mail"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "footer_text"
    t.string "client_cellphone", default: "(31) 99999-9999"
    t.string "professional_cellphone", default: "(31) 99999-9999"
    t.string "size_banner_link"
    t.text "melhor_envio_access_token"
    t.text "melhor_envio_refresh_token"
    t.date "melhor_envio_expires_date"
  end

  create_table "user_plans", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "plan_id"
    t.datetime "initial_date"
    t.datetime "final_date"
    t.decimal "price", precision: 15, scale: 2
    t.date "next_payment"
    t.integer "count_paid", default: 0
    t.decimal "plan_price", precision: 15, scale: 2
    t.boolean "use_discount_coupon", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "validate_date"
    t.bigint "order_id"
    t.integer "quantity_months_discount", default: 1
    t.index ["order_id"], name: "index_user_plans_on_order_id"
    t.index ["plan_id"], name: "index_user_plans_on_plan_id"
    t.index ["user_id"], name: "index_user_plans_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "access_user"
    t.string "password_digest"
    t.string "recovery_token"
    t.boolean "is_blocked", default: false
    t.bigint "profile_id"
    t.string "phone"
    t.string "cpf"
    t.string "rg"
    t.date "birthday"
    t.bigint "person_type_id"
    t.bigint "sex_id"
    t.bigint "payment_type_id"
    t.bigint "civil_state_id"
    t.string "social_name"
    t.string "fantasy_name"
    t.string "cnpj"
    t.boolean "accept_therm", default: false
    t.string "cellphone"
    t.string "profession"
    t.string "provider", limit: 50, default: "", null: false
    t.string "uid", limit: 500, default: "", null: false
    t.boolean "seller_verified", default: false
    t.boolean "publish_professional_profile", default: false
    t.text "description", size: :long
    t.text "work_experience", size: :long
    t.decimal "deadline_avaliation", precision: 15, scale: 2
    t.decimal "quality_avaliation", precision: 15, scale: 2
    t.decimal "problems_solution_avaliation", precision: 15, scale: 2
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "icms_contribution_id"
    t.index ["civil_state_id"], name: "index_users_on_civil_state_id"
    t.index ["icms_contribution_id"], name: "index_users_on_icms_contribution_id"
    t.index ["payment_type_id"], name: "index_users_on_payment_type_id"
    t.index ["person_type_id"], name: "index_users_on_person_type_id"
    t.index ["profile_id"], name: "index_users_on_profile_id"
    t.index ["sex_id"], name: "index_users_on_sex_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "addresses", "address_areas"
  add_foreign_key "addresses", "address_types"
  add_foreign_key "addresses", "cities"
  add_foreign_key "addresses", "countries"
  add_foreign_key "addresses", "states"
  add_foreign_key "banners", "banner_areas"
  add_foreign_key "cancel_orders", "cancel_order_reasons"
  add_foreign_key "cancel_orders", "freight_orders"
  add_foreign_key "cancel_orders", "orders"
  add_foreign_key "cards", "card_banners"
  add_foreign_key "categories", "category_types"
  add_foreign_key "cities", "countries"
  add_foreign_key "cities", "states"
  add_foreign_key "data_banks", "banks"
  add_foreign_key "data_banks", "data_bank_types"
  add_foreign_key "data_professionals", "professional_document_statuses"
  add_foreign_key "data_professionals", "users"
  add_foreign_key "data_professionals_specialties", "data_professionals"
  add_foreign_key "data_professionals_specialties", "specialties"
  add_foreign_key "emails", "email_types"
  add_foreign_key "freight_order_options", "freight_companies"
  add_foreign_key "freight_order_options", "freight_order_statuses"
  add_foreign_key "freight_order_options", "freight_orders"
  add_foreign_key "freight_orders", "orders"
  add_foreign_key "messages", "orders"
  add_foreign_key "order_carts", "orders"
  add_foreign_key "order_carts", "seller_coupons"
  add_foreign_key "orders", "order_statuses"
  add_foreign_key "orders", "order_type_recurrents"
  add_foreign_key "orders", "payment_types"
  add_foreign_key "orders", "seller_coupons"
  add_foreign_key "orders", "users"
  add_foreign_key "payment_transactions", "payment_statuses"
  add_foreign_key "phones", "phone_types"
  add_foreign_key "plan_services", "plans"
  add_foreign_key "plans", "categories"
  add_foreign_key "plans", "plan_periodicities"
  add_foreign_key "plans", "plan_types"
  add_foreign_key "plans", "sub_categories"
  add_foreign_key "products", "categories"
  add_foreign_key "products", "product_conditions"
  add_foreign_key "products", "sub_categories"
  add_foreign_key "products", "users"
  add_foreign_key "professional_avaliations", "orders"
  add_foreign_key "seller_coupons", "coupon_areas"
  add_foreign_key "seller_coupons", "coupon_types"
  add_foreign_key "seller_coupons_users", "seller_coupons"
  add_foreign_key "seller_coupons_users", "users"
  add_foreign_key "services", "categories"
  add_foreign_key "services", "radius_services"
  add_foreign_key "services", "sub_categories"
  add_foreign_key "services", "users"
  add_foreign_key "site_contacts", "site_contact_subjects"
  add_foreign_key "site_contacts", "users"
  add_foreign_key "states", "countries"
  add_foreign_key "sub_categories", "categories"
  add_foreign_key "user_plans", "orders"
  add_foreign_key "user_plans", "plans"
  add_foreign_key "user_plans", "users"
  add_foreign_key "users", "civil_states"
  add_foreign_key "users", "icms_contributions"
  add_foreign_key "users", "payment_types"
  add_foreign_key "users", "person_types"
  add_foreign_key "users", "profiles"
  add_foreign_key "users", "sexes"
end
