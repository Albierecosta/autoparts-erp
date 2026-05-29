class CreateSuppliers < ActiveRecord::Migration[8.1]
  def change
    create_table :suppliers do |t|
      t.references :company, null: false, foreign_key: true
      t.string :name, null: false
      t.string :trade_name
      t.string :cnpj
      t.string :phone
      t.string :email
      t.string :contact_name
      t.string :address
      t.string :city
      t.string :state
      t.string :zip_code
      t.text :notes
      t.boolean :active, default: true

      t.timestamps
    end

    add_index :suppliers, [:company_id, :cnpj]
  end
end
