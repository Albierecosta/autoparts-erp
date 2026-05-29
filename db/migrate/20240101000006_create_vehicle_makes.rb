class CreateVehicleMakes < ActiveRecord::Migration[8.1]
  def change
    create_table :vehicle_makes do |t|
      t.string :name, null: false
      t.string :country
      t.boolean :active, default: true

      t.timestamps
    end

    add_index :vehicle_makes, :name, unique: true
  end
end
