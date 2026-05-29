class FinancialTransaction < ApplicationRecord
  belongs_to :company
  belongs_to :user
  belongs_to :sale, optional: true
  belongs_to :customer, optional: true
  belongs_to :supplier, optional: true

  TRANSACTION_TYPES = %w[income expense].freeze
  PAYMENT_METHODS = %w[cash credit_card debit_card pix bank_transfer other].freeze
  STATUSES = %w[pending paid cancelled].freeze
  CATEGORIES = {
    income: %w[sale service other_income],
    expense: %w[purchase payroll rent utilities marketing other_expense]
  }.freeze

  validates :transaction_type, inclusion: { in: TRANSACTION_TYPES }
  validates :description, presence: true
  validates :amount, numericality: { greater_than: 0 }
  validates :status, inclusion: { in: STATUSES }

  scope :income, -> { where(transaction_type: "income") }
  scope :expense, -> { where(transaction_type: "expense") }
  scope :paid, -> { where(status: "paid") }
  scope :pending, -> { where(status: "pending") }
  scope :overdue, -> { where("due_date < ? AND status = ?", Date.current, "pending") }
  scope :this_month, -> { where(created_at: Time.current.all_month) }
  scope :ordered, -> { order(due_date: :asc) }

  def income?
    transaction_type == "income"
  end

  def expense?
    transaction_type == "expense"
  end

  def pending?
    status == "pending"
  end

  def paid?
    status == "paid"
  end

  def cancelled?
    status == "cancelled"
  end

  def overdue?
    due_date.present? && due_date < Date.current && !paid?
  end

  def mark_as_paid!(date = nil)
    update!(status: "paid", paid_at: date || Date.current)
  end
end
