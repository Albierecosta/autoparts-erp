class Company < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :suppliers, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :customers, dependent: :destroy
  has_many :sales, dependent: :destroy
  has_many :stock_movements, dependent: :destroy
  has_many :financial_transactions, dependent: :destroy

  has_one_attached :logo

  validates :name, presence: true
  validates :cnpj, uniqueness: true, allow_blank: true

  store_accessor :settings,
    :low_stock_alert_enabled,
    :default_payment_method,
    :receipt_footer,
    :currency_symbol,
    :timezone

  def settings
    super || {}
  end

  def ecommerce_active?
    ecommerce_enabled?
  end

  def currency
    settings["currency_symbol"] || "R$"
  end
end
