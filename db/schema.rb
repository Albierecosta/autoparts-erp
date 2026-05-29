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

ActiveRecord::Schema[8.1].define(version: 2026_05_29_194558) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_trgm"
  enable_extension "unaccent"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.boolean "active", default: true
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "icon"
    t.string "name", null: false
    t.integer "position", default: 0
    t.string "slug"
    t.datetime "updated_at", null: false
    t.index ["company_id", "slug"], name: "index_categories_on_company_id_and_slug", unique: true
    t.index ["company_id"], name: "index_categories_on_company_id"
  end

  create_table "companies", force: :cascade do |t|
    t.boolean "active", default: true
    t.string "address"
    t.string "city"
    t.string "cnpj"
    t.datetime "created_at", null: false
    t.boolean "ecommerce_enabled", default: false
    t.string "email"
    t.string "logo"
    t.string "name", null: false
    t.string "phone"
    t.text "settings", default: "{}"
    t.string "state"
    t.string "trade_name"
    t.datetime "updated_at", null: false
    t.string "zip_code"
    t.index ["cnpj"], name: "index_companies_on_cnpj", unique: true
  end

  create_table "customer_vehicles", force: :cascade do |t|
    t.string "chassis"
    t.string "color"
    t.datetime "created_at", null: false
    t.bigint "customer_id", null: false
    t.text "notes"
    t.string "plate"
    t.datetime "updated_at", null: false
    t.bigint "vehicle_make_id"
    t.bigint "vehicle_model_id"
    t.string "year"
    t.index ["customer_id"], name: "index_customer_vehicles_on_customer_id"
    t.index ["plate"], name: "index_customer_vehicles_on_plate"
    t.index ["vehicle_make_id"], name: "index_customer_vehicles_on_vehicle_make_id"
    t.index ["vehicle_model_id"], name: "index_customer_vehicles_on_vehicle_model_id"
  end

  create_table "customers", force: :cascade do |t|
    t.boolean "active", default: true
    t.string "address"
    t.date "birthdate"
    t.string "city"
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.string "document"
    t.string "document_type", default: "cpf"
    t.string "email"
    t.string "mobile"
    t.string "name", null: false
    t.text "notes"
    t.string "phone"
    t.string "state"
    t.datetime "updated_at", null: false
    t.string "zip_code"
    t.index ["company_id", "document"], name: "index_customers_on_company_id_and_document"
    t.index ["company_id"], name: "index_customers_on_company_id"
    t.index ["name"], name: "index_customers_on_name"
  end

  create_table "financial_transactions", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.string "category"
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.bigint "customer_id"
    t.string "description", null: false
    t.date "due_date"
    t.text "notes"
    t.date "paid_at"
    t.string "payment_method"
    t.string "reference_number"
    t.bigint "sale_id"
    t.string "status", default: "pending"
    t.bigint "supplier_id"
    t.string "transaction_type", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["company_id", "status"], name: "index_financial_transactions_on_company_id_and_status"
    t.index ["company_id", "transaction_type"], name: "idx_on_company_id_transaction_type_f252e84ed0"
    t.index ["company_id"], name: "index_financial_transactions_on_company_id"
    t.index ["customer_id"], name: "index_financial_transactions_on_customer_id"
    t.index ["due_date"], name: "index_financial_transactions_on_due_date"
    t.index ["sale_id"], name: "index_financial_transactions_on_sale_id"
    t.index ["supplier_id"], name: "index_financial_transactions_on_supplier_id"
    t.index ["user_id"], name: "index_financial_transactions_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.boolean "active", default: true
    t.string "barcode"
    t.string "brand"
    t.bigint "category_id"
    t.bigint "company_id", null: false
    t.decimal "cost_price", precision: 10, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "dimensions"
    t.boolean "featured", default: false
    t.string "internal_code"
    t.integer "max_stock"
    t.integer "min_stock", default: 5
    t.string "name", null: false
    t.integer "online_stock"
    t.decimal "promotional_price", precision: 10, scale: 2
    t.boolean "published", default: false
    t.decimal "sale_price", precision: 10, scale: 2, default: "0.0"
    t.string "sku"
    t.integer "stock_quantity", default: 0
    t.string "stock_unit", default: "un"
    t.bigint "supplier_id"
    t.datetime "updated_at", null: false
    t.decimal "weight", precision: 8, scale: 3
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["company_id", "barcode"], name: "index_products_on_company_id_and_barcode"
    t.index ["company_id", "internal_code"], name: "index_products_on_company_id_and_internal_code", unique: true
    t.index ["company_id", "sku"], name: "index_products_on_company_id_and_sku"
    t.index ["company_id"], name: "index_products_on_company_id"
    t.index ["name"], name: "index_products_on_name"
    t.index ["supplier_id"], name: "index_products_on_supplier_id"
  end

  create_table "sale_items", force: :cascade do |t|
    t.decimal "cost_price", precision: 10, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.decimal "discount_amount", precision: 10, scale: 2, default: "0.0"
    t.string "product_code"
    t.bigint "product_id", null: false
    t.string "product_name"
    t.integer "quantity", default: 1, null: false
    t.bigint "sale_id", null: false
    t.decimal "total", precision: 10, scale: 2, null: false
    t.decimal "unit_price", precision: 10, scale: 2, null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_sale_items_on_product_id"
    t.index ["sale_id"], name: "index_sale_items_on_sale_id"
  end

  create_table "sales", force: :cascade do |t|
    t.string "cancel_reason"
    t.datetime "cancelled_at"
    t.bigint "company_id", null: false
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.bigint "customer_id"
    t.decimal "discount_amount", precision: 10, scale: 2, default: "0.0"
    t.decimal "discount_percent", precision: 5, scale: 2, default: "0.0"
    t.text "notes"
    t.string "number", null: false
    t.string "payment_method"
    t.string "payment_status", default: "pending"
    t.string "sale_type", default: "sale"
    t.string "status", default: "pending"
    t.decimal "subtotal", precision: 10, scale: 2, default: "0.0"
    t.decimal "total", precision: 10, scale: 2, default: "0.0"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["company_id", "number"], name: "index_sales_on_company_id_and_number", unique: true
    t.index ["company_id", "status"], name: "index_sales_on_company_id_and_status"
    t.index ["company_id"], name: "index_sales_on_company_id"
    t.index ["created_at"], name: "index_sales_on_created_at"
    t.index ["customer_id"], name: "index_sales_on_customer_id"
    t.index ["user_id"], name: "index_sales_on_user_id"
  end

  create_table "stock_movements", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.integer "current_stock"
    t.string "movement_type", null: false
    t.integer "previous_stock"
    t.bigint "product_id", null: false
    t.integer "quantity", null: false
    t.text "reason"
    t.string "reference_number"
    t.bigint "sale_id"
    t.bigint "supplier_id"
    t.decimal "unit_cost", precision: 10, scale: 2
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["company_id", "product_id"], name: "index_stock_movements_on_company_id_and_product_id"
    t.index ["company_id"], name: "index_stock_movements_on_company_id"
    t.index ["created_at"], name: "index_stock_movements_on_created_at"
    t.index ["product_id"], name: "index_stock_movements_on_product_id"
    t.index ["sale_id"], name: "index_stock_movements_on_sale_id"
    t.index ["supplier_id"], name: "index_stock_movements_on_supplier_id"
    t.index ["user_id"], name: "index_stock_movements_on_user_id"
  end

  create_table "suppliers", force: :cascade do |t|
    t.boolean "active", default: true
    t.string "address"
    t.string "city"
    t.string "cnpj"
    t.bigint "company_id", null: false
    t.string "contact_name"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name", null: false
    t.text "notes"
    t.string "phone"
    t.string "state"
    t.string "trade_name"
    t.datetime "updated_at", null: false
    t.string "zip_code"
    t.index ["company_id", "cnpj"], name: "index_suppliers_on_company_id_and_cnpj"
    t.index ["company_id"], name: "index_suppliers_on_company_id"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "active", default: true
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "last_sign_in_at"
    t.string "last_sign_in_ip"
    t.string "name", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "role", default: "operator"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vehicle_applications", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "engine"
    t.text "notes"
    t.bigint "product_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "vehicle_make_id", null: false
    t.bigint "vehicle_model_id", null: false
    t.string "version"
    t.string "year_from"
    t.string "year_to"
    t.index ["product_id", "vehicle_make_id", "vehicle_model_id"], name: "idx_vehicle_applications_product_make_model"
    t.index ["product_id"], name: "index_vehicle_applications_on_product_id"
    t.index ["vehicle_make_id"], name: "index_vehicle_applications_on_vehicle_make_id"
    t.index ["vehicle_model_id"], name: "index_vehicle_applications_on_vehicle_model_id"
  end

  create_table "vehicle_makes", force: :cascade do |t|
    t.boolean "active", default: true
    t.string "country"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_vehicle_makes_on_name", unique: true
  end

  create_table "vehicle_models", force: :cascade do |t|
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.bigint "vehicle_make_id", null: false
    t.index ["vehicle_make_id", "name"], name: "index_vehicle_models_on_vehicle_make_id_and_name", unique: true
    t.index ["vehicle_make_id"], name: "index_vehicle_models_on_vehicle_make_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "categories", "companies"
  add_foreign_key "customer_vehicles", "customers"
  add_foreign_key "customer_vehicles", "vehicle_makes"
  add_foreign_key "customer_vehicles", "vehicle_models"
  add_foreign_key "customers", "companies"
  add_foreign_key "financial_transactions", "companies"
  add_foreign_key "financial_transactions", "customers"
  add_foreign_key "financial_transactions", "sales"
  add_foreign_key "financial_transactions", "suppliers"
  add_foreign_key "financial_transactions", "users"
  add_foreign_key "products", "categories"
  add_foreign_key "products", "companies"
  add_foreign_key "products", "suppliers"
  add_foreign_key "sale_items", "products"
  add_foreign_key "sale_items", "sales"
  add_foreign_key "sales", "companies"
  add_foreign_key "sales", "customers"
  add_foreign_key "sales", "users"
  add_foreign_key "stock_movements", "companies"
  add_foreign_key "stock_movements", "products"
  add_foreign_key "stock_movements", "sales"
  add_foreign_key "stock_movements", "suppliers"
  add_foreign_key "stock_movements", "users"
  add_foreign_key "suppliers", "companies"
  add_foreign_key "users", "companies"
  add_foreign_key "vehicle_applications", "products"
  add_foreign_key "vehicle_applications", "vehicle_makes"
  add_foreign_key "vehicle_applications", "vehicle_models"
  add_foreign_key "vehicle_models", "vehicle_makes"
end
