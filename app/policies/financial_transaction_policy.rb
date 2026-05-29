class FinancialTransactionPolicy < ApplicationPolicy
  def pay? = user.can_manage?

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(company: user.company)
    end
  end
end
