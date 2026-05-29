class Customer < ApplicationRecord
  belongs_to :company
  has_many :customer_vehicles, dependent: :destroy
  has_many :sales, dependent: :nullify
  has_many :financial_transactions, dependent: :nullify

  validates :name, presence: true

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(:name) }
  scope :search_by_name, ->(q) { where("name ILIKE ?", "%#{q}%") if q.present? }

  def display_name
    name
  end

  def formatted_document
    return "" if document.blank?
    document
  end
end
