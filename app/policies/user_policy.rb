class UserPolicy < ApplicationPolicy
  def index? = user.admin?
  def show? = user.admin?
  def create? = user.admin?
  def update? = user.admin?
  def destroy? = user.admin?

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(company: user.company)
    end
  end
end
