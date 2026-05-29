module Settings
  class CompanyPolicy < ApplicationPolicy
    def show? = user.admin?
    def edit? = user.admin?
    def update? = user.admin?
  end
end
