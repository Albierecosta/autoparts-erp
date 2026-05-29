class VehicleMakePolicy < ApplicationPolicy
  def index? = user.active?
  def show? = user.active?

  class Scope
    def initialize(user, scope) = (@user, @scope = user, scope)
    def resolve = @scope.all
    private
    attr_reader :user, :scope
  end
end
