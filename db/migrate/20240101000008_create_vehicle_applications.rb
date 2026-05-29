class CreateVehicleApplications < ActiveRecord::Migration[8.1]
  def change
    create_table :vehicle_applications do |t|
      t.references :product, null: false, foreign_key: true
      t.references :vehicle_make, null: false, foreign_key: true
      t.references :vehicle_model, null: false, foreign_key: true
      t.string :year_from
      t.string :year_to
      t.string :engine
      t.string :version
      t.text :notes

      t.timestamps
    end

    add_index :vehicle_applications, [:product_id, :vehicle_make_id, :vehicle_model_id], name: "idx_vehicle_applications_product_make_model"
  end
end
