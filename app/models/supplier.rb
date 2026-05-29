class Supplier < ApplicationRecord
  belongs_to :company
  has_many :products, dependent: :nullify
  has_many :stock_movements, dependent: :nullify
  has_many :financial_transactions, dependent: :nullify

  validates :name, presence: true

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(:name) }
end
