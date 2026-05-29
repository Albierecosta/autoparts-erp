class CreateSaleItems < ActiveRecord::Migration[8.1]
  def change
    create_table :sale_items do |t|
      t.references :sale, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true

      t.string :product_name
      t.string :product_code
      t.integer :quantity, null: false, default: 1
      t.decimal :unit_price, precision: 10, scale: 2, null: false
      t.decimal :cost_price, precision: 10, scale: 2, default: 0
      t.decimal :discount_amount, precision: 10, scale: 2, default: 0
      t.decimal :total, precision: 10, scale: 2, null: false

      t.timestamps
    end
  end
end
