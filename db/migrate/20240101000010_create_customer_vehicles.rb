class CreateCustomerVehicles < ActiveRecord::Migration[8.1]
  def change
    create_table :customer_vehicles do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :vehicle_make, foreign_key: true
      t.references :vehicle_model, foreign_key: true
      t.string :year
      t.string :plate
      t.string :color
      t.string :chassis
      t.text :notes

      t.timestamps
    end

    add_index :customer_vehicles, :plate
  end
end
