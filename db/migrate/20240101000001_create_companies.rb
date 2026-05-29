class CreateCompanies < ActiveRecord::Migration[8.1]
  def change
    create_table :companies do |t|
      t.string :name, null: false
      t.string :trade_name
      t.string :cnpj
      t.string :phone
      t.string :email
      t.string :address
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :logo
      t.text :settings, default: "{}"
      t.boolean :ecommerce_enabled, default: false
      t.boolean :active, default: true

      t.timestamps
    end

    add_index :companies, :cnpj, unique: true
  end
end
