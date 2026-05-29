class CreateCustomers < ActiveRecord::Migration[8.1]
  def change
    create_table :customers do |t|
      t.references :company, null: false, foreign_key: true
      t.string :name, null: false
      t.string :document
      t.string :document_type, default: "cpf"
      t.string :phone
      t.string :mobile
      t.string :email
      t.string :address
      t.string :city
      t.string :state
      t.string :zip_code
      t.date :birthdate
      t.text :notes
      t.boolean :active, default: true

      t.timestamps
    end

    add_index :customers, [:company_id, :document]
    add_index :customers, :name
  end
end
