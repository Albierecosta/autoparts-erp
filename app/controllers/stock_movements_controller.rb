class StockMovementsController < ApplicationController
  before_action :set_product, only: [:index, :new, :create]

  def index
    authorize StockMovement
    scope = policy_scope(StockMovement).includes(:product, :user, :sale, :supplier)

    if @product
      scope = scope.where(product: @product)
    end

    scope = scope.where(movement_type: params[:movement_type]) if params[:movement_type].present?
    scope = scope.ordered

    @pagy, @movements = pagy(scope, limit: 25)
  end

  def new
    @movement = current_company.stock_movements.new(product: @product)
    authorize @movement
    @products = policy_scope(Product).active.ordered unless @product
    @suppliers = policy_scope(Supplier).active.ordered
  end

  def create
    @movement = current_company.stock_movements.new(movement_params)
    @movement.user = current_user
    authorize @movement

    if StockService.new(@movement).process!
      redirect_to stock_movements_path, notice: "Movimentação registrada com sucesso."
    else
      @products = policy_scope(Product).active.ordered unless @product
      @suppliers = policy_scope(Supplier).active.ordered
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_product
    @product = policy_scope(Product).find(params[:product_id]) if params[:product_id].present?
  end

  def movement_params
    params.require(:stock_movement).permit(
      :product_id, :movement_type, :quantity, :unit_cost,
      :reason, :reference_number, :supplier_id
    )
  end
end
