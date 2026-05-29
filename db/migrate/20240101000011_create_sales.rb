class CreateSales < ActiveRecord::Migration[8.1]
  def change
    create_table :sales do |t|
      t.references :company, null: false, foreign_key: true
      t.references :customer, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.string :number, null: false
      t.string :status, default: "pending"
      t.string :sale_type, default: "sale"

      t.decimal :subtotal, precision: 10, scale: 2, default: 0
      t.decimal :discount_amount, precision: 10, scale: 2, default: 0
      t.decimal :discount_percent, precision: 5, scale: 2, default: 0
      t.decimal :total, precision: 10, scale: 2, default: 0

      t.string :payment_method
      t.string :payment_status, default: "pending"
      t.text :notes
      t.datetime :confirmed_at
      t.datetime :cancelled_at
      t.string :cancel_reason

      t.timestamps
    end

    add_index :sales, [:company_id, :number], unique: true
    add_index :sales, [:company_id, :status]
    add_index :sales, :created_at
  end
end
