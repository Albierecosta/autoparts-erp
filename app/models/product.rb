class Product < ApplicationRecord
  include PgSearch::Model

  belongs_to :company
  belongs_to :category, optional: true
  belongs_to :supplier, optional: true

  has_many :vehicle_applications, dependent: :destroy
  has_many :vehicle_makes, through: :vehicle_applications
  has_many :vehicle_models, through: :vehicle_applications
  has_many :sale_items, dependent: :restrict_with_error
  has_many :stock_movements, dependent: :destroy

  has_many_attached :photos

  validates :name, presence: true
  validates :sale_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :cost_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :stock_quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :internal_code, uniqueness: { scope: :company_id }, allow_blank: true

  scope :active, -> { where(active: true) }
  scope :low_stock, -> { where("stock_quantity <= min_stock AND min_stock > 0") }
  scope :out_of_stock, -> { where(stock_quantity: 0) }
  scope :published, -> { where(published: true) }
  scope :ordered, -> { order(:name) }

  pg_search_scope :full_text_search,
    against: [:name, :internal_code, :sku, :brand, :description],
    associated_against: {
      vehicle_makes: [:name],
      vehicle_models: [:name]
    },
    using: {
      tsearch: { prefix: true, any_word: true },
      trigram: { threshold: 0.1 }
    }

  def low_stock?
    min_stock.to_i > 0 && stock_quantity <= min_stock
  end

  def out_of_stock?
    stock_quantity <= 0
  end

  def profit_margin
    return 0 if cost_price.to_f.zero?
    ((sale_price - cost_price) / cost_price * 100).round(2)
  end

  def stock_status
    return :out_of_stock if out_of_stock?
    return :low_stock if low_stock?
    :in_stock
  end

  def primary_photo
    photos.first
  end
end
