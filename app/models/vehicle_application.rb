class VehicleApplication < ApplicationRecord
  belongs_to :product
  belongs_to :vehicle_make
  belongs_to :vehicle_model

  validates :vehicle_make, presence: true
  validates :vehicle_model, presence: true

  def description
    parts = [vehicle_make.name, vehicle_model.name]
    parts << "#{year_from}-#{year_to}" if year_from.present?
    parts << engine if engine.present?
    parts << version if version.present?
    parts.join(" ")
  end
end
