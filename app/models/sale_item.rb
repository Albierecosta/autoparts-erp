class SaleItem < ApplicationRecord
  belongs_to :sale
  belongs_to :product

  validates :quantity, numericality: { greater_than: 0, only_integer: true }
  validates :unit_price, numericality: { greater_than_or_equal_to: 0 }

  before_validation :set_product_details
  before_validation :calculate_total

  def subtotal
    quantity * unit_price
  end

  private

  def set_product_details
    return unless product
    self.product_name ||= product.name
    self.product_code ||= product.internal_code
    self.cost_price ||= product.cost_price
    self.unit_price ||= product.sale_price
  end

  def calculate_total
    self.total = (quantity.to_i * unit_price.to_f) - discount_amount.to_f
  end
end
