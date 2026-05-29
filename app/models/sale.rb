class Sale < ApplicationRecord
  belongs_to :company
  belongs_to :customer, optional: true
  belongs_to :user

  has_many :sale_items, dependent: :destroy
  has_many :products, through: :sale_items
  has_many :financial_transactions, dependent: :nullify

  accepts_nested_attributes_for :sale_items, allow_destroy: true,
    reject_if: ->(attrs) { attrs["product_id"].blank? }

  STATUSES = %w[pending confirmed cancelled].freeze
  SALE_TYPES = %w[sale quote].freeze
  PAYMENT_METHODS = %w[cash credit_card debit_card pix bank_transfer other].freeze
  PAYMENT_STATUSES = %w[pending paid partial].freeze

  validates :number, presence: true, uniqueness: { scope: :company_id }, on: :update
  validates :status, inclusion: { in: STATUSES }
  validates :sale_type, inclusion: { in: SALE_TYPES }
  validates :total, numericality: { greater_than_or_equal_to: 0 }
  validate :must_have_at_least_one_item, on: :create

  scope :confirmed, -> { where(status: "confirmed") }
  scope :pending, -> { where(status: "pending") }
  scope :quotes, -> { where(sale_type: "quote") }
  scope :sales_only, -> { where(sale_type: "sale") }
  scope :today, -> { where(created_at: Time.current.all_day) }
  scope :this_month, -> { where(created_at: Time.current.all_month) }
  scope :ordered, -> { order(created_at: :desc) }

  before_validation :set_number, on: :create
  before_validation :calculate_totals, on: [:create, :update]

  def confirm!
    return false if confirmed?
    update!(status: "confirmed", confirmed_at: Time.current)
  end

  def cancel!(reason = nil)
    return false if cancelled?
    update!(status: "cancelled", cancelled_at: Time.current, cancel_reason: reason)
  end

  def confirmed?
    status == "confirmed"
  end

  def cancelled?
    status == "cancelled"
  end

  def pending?
    status == "pending"
  end

  def quote?
    sale_type == "quote"
  end

  def payment_method_label
    I18n.t("payment_methods.#{payment_method}", default: payment_method.to_s.humanize)
  end

  private

  def calculate_totals
    items = sale_items.reject(&:marked_for_destruction?)
    self.subtotal = items.sum { |i| i.total.to_f.nonzero? || (i.quantity.to_i * i.unit_price.to_f) }
    discount = discount_amount.to_f
    if discount_percent.to_f > 0 && discount_amount.to_f.zero?
      discount = subtotal * discount_percent / 100
      self.discount_amount = discount.round(2)
    end
    self.total = [subtotal - discount, 0].max.round(2)
  end

  def set_number
    last_number = company.sales.maximum(:number).to_i
    self.number = format("%06d", last_number + 1)
  end

  def must_have_at_least_one_item
    valid_items = sale_items.reject(&:marked_for_destruction?).reject { |i| i.product_id.blank? }
    errors.add(:base, "Adicione pelo menos um produto à venda") if valid_items.empty?
  end
end
