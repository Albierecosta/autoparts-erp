class SalePolicy < ApplicationPolicy
  def confirm? = user.active?
  def cancel? = user.can_manage?
  def receipt? = user.active?

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(company: user.company)
    end
  end
end
