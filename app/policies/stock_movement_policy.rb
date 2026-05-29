class StockMovementPolicy < ApplicationPolicy
  def create? = user.can_manage?
  def destroy? = false

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(company: user.company)
    end
  end
end
