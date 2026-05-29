class CreateStockMovements < ActiveRecord::Migration[8.1]
  def change
    create_table :stock_movements do |t|
      t.references :company, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :sale, foreign_key: true
      t.references :supplier, foreign_key: true

      t.string :movement_type, null: false
      t.integer :quantity, null: false
      t.integer :previous_stock
      t.integer :current_stock
      t.decimal :unit_cost, precision: 10, scale: 2
      t.text :reason
      t.string :reference_number

      t.timestamps
    end

    add_index :stock_movements, [:company_id, :product_id]
    add_index :stock_movements, :created_at
  end
end
