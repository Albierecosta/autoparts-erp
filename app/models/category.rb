class Category < ApplicationRecord
  belongs_to :company
  has_many :products, dependent: :nullify

  validates :name, presence: true
  validates :slug, uniqueness: { scope: :company_id }, allow_blank: true

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(:position, :name) }

  before_validation :generate_slug

  private

  def generate_slug
    self.slug = name.to_s.parameterize if slug.blank? && name.present?
  end
end
