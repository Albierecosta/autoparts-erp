class CustomerVehicle < ApplicationRecord
  belongs_to :customer
  belongs_to :vehicle_make, optional: true
  belongs_to :vehicle_model, optional: true

  def description
    parts = []
    parts << vehicle_make.name if vehicle_make
    parts << vehicle_model.name if vehicle_model
    parts << year if year.present?
    parts << plate if plate.present?
    parts.join(" - ")
  end
end
