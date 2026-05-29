class CreateFinancialTransactions < ActiveRecord::Migration[8.1]
  def change
    create_table :financial_transactions do |t|
      t.references :company, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :sale, foreign_key: true
      t.references :customer, foreign_key: true
      t.references :supplier, foreign_key: true

      t.string :transaction_type, null: false
      t.string :category
      t.string :description, null: false
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.string :payment_method
      t.string :status, default: "pending"
      t.date :due_date
      t.date :paid_at
      t.string :reference_number
      t.text :notes

      t.timestamps
    end

    add_index :financial_transactions, [:company_id, :transaction_type]
    add_index :financial_transactions, [:company_id, :status]
    add_index :financial_transactions, :due_date
  end
end
