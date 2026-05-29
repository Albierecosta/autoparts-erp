class VehicleModel < ApplicationRecord
  belongs_to :vehicle_make
  has_many :vehicle_applications, dependent: :destroy
  has_many :customer_vehicles, dependent: :nullify

  validates :name, presence: true
  validates :name, uniqueness: { scope: :vehicle_make_id }

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(:name) }

  def full_name
    "#{vehicle_make.name} #{name}"
  end
end
