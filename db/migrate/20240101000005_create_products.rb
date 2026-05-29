class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.references :company, null: false, foreign_key: true
      t.references :category, foreign_key: true
      t.references :supplier, foreign_key: true

      t.string :name, null: false
      t.string :internal_code
      t.string :sku
      t.string :brand
      t.string :barcode
      t.text :description

      t.decimal :cost_price, precision: 10, scale: 2, default: 0
      t.decimal :sale_price, precision: 10, scale: 2, default: 0
      t.decimal :promotional_price, precision: 10, scale: 2

      t.integer :stock_quantity, default: 0
      t.integer :min_stock, default: 5
      t.integer :max_stock
      t.string :stock_unit, default: "un"

      t.decimal :weight, precision: 8, scale: 3
      t.string :dimensions

      # E-commerce fields
      t.boolean :published, default: false
      t.boolean :featured, default: false
      t.integer :online_stock

      t.boolean :active, default: true

      t.timestamps
    end

    add_index :products, [:company_id, :internal_code], unique: true
    add_index :products, [:company_id, :sku]
    add_index :products, [:company_id, :barcode]
    add_index :products, :name
  end
end
