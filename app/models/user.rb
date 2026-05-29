class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :company

  ROLES = %w[admin manager operator].freeze

  validates :name, presence: true
  validates :role, inclusion: { in: ROLES }

  scope :active, -> { where(active: true) }
  scope :admins, -> { where(role: "admin") }
  scope :ordered_by_name, -> { order(:name) }

  def admin?
    role == "admin"
  end

  def manager?
    role == "manager"
  end

  def operator?
    role == "operator"
  end

  def can_manage?
    admin? || manager?
  end
end
