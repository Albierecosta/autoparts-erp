class VehicleMake < ApplicationRecord
  has_many :vehicle_models, dependent: :destroy
  has_many :vehicle_applications, dependent: :destroy
  has_many :customer_vehicles, dependent: :nullify

  validates :name, presence: true, uniqueness: true

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(:name) }
end
