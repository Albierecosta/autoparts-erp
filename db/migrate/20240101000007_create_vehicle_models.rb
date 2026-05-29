class CreateVehicleModels < ActiveRecord::Migration[8.1]
  def change
    create_table :vehicle_models do |t|
      t.references :vehicle_make, null: false, foreign_key: true
      t.string :name, null: false
      t.boolean :active, default: true

      t.timestamps
    end

    add_index :vehicle_models, [:vehicle_make_id, :name], unique: true
  end
end
