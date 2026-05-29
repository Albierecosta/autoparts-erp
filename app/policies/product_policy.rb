class ProductPolicy < ApplicationPolicy
  def update? = user.can_manage?
  def destroy? = user.admin?

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(company: user.company)
    end
  end
end
