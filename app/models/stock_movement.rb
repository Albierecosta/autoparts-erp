class StockMovement < ApplicationRecord
  belongs_to :company
  belongs_to :product
  belongs_to :user
  belongs_to :sale, optional: true
  belongs_to :supplier, optional: true

  MOVEMENT_TYPES = %w[entry exit adjustment sale_out purchase return].freeze

  validates :movement_type, inclusion: { in: MOVEMENT_TYPES }
  validates :quantity, numericality: { other_than: 0 }

  scope :stock_entries, -> { where(movement_type: %w[entry purchase return]) }
  scope :stock_exits, -> { where(movement_type: %w[exit sale_out]) }
  scope :ordered, -> { order(created_at: :desc) }
  scope :for_product, ->(product_id) { where(product_id: product_id) }

  def entry?
    %w[entry purchase return].include?(movement_type)
  end

  def exit?
    %w[exit sale_out].include?(movement_type)
  end

  def movement_type_label
    I18n.t("stock_movement_types.#{movement_type}", default: movement_type.humanize)
  end
end
