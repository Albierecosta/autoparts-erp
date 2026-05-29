class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index? = user.active?
  def show? = user.active?
  def create? = user.active?
  def new? = create?
  def update? = user.can_manage?
  def edit? = update?
  def destroy? = user.admin?

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.where(company: user.company)
    end

    private

    attr_reader :user, :scope
  end
end
