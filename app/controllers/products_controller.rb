class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    authorize Product
    scope = policy_scope(Product).includes(:category, :supplier)

    if params[:q].present?
      scope = scope.full_text_search(params[:q])
    end

    scope = scope.where(category_id: params[:category_id]) if params[:category_id].present?
    scope = scope.where(active: params[:active]) if params[:active].present?
    scope = scope.low_stock if params[:low_stock].present?

    scope = scope.order(:name)

    @pagy, @products = pagy(scope, limit: 25)
    @categories = policy_scope(Category).active.ordered
  end

  def show
    authorize @product
  end

  def new
    @product = current_company.products.new
    authorize @product
    load_form_data
  end

  def create
    @product = current_company.products.new(product_params)
    authorize @product

    if @product.save
      redirect_to @product, notice: "Produto criado com sucesso."
    else
      load_form_data
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @product
    load_form_data
  end

  def update
    authorize @product

    if @product.update(product_params)
      redirect_to @product, notice: "Produto atualizado com sucesso."
    else
      load_form_data
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @product

    if @product.sale_items.any?
      redirect_to @product, alert: "Produto não pode ser removido pois possui vendas vinculadas."
    else
      @product.destroy
      redirect_to products_path, notice: "Produto removido com sucesso."
    end
  end

  private

  def set_product
    @product = policy_scope(Product).find(params[:id])
  end

  def load_form_data
    @categories = policy_scope(Category).active.ordered
    @suppliers = policy_scope(Supplier).active.ordered
    @vehicle_makes = VehicleMake.active.ordered
  end

  def product_params
    params.require(:product).permit(
      :name, :internal_code, :sku, :brand, :barcode,
      :description, :cost_price, :sale_price, :promotional_price,
      :stock_quantity, :min_stock, :max_stock, :stock_unit,
      :weight, :dimensions, :category_id, :supplier_id,
      :active, :published, :featured,
      photos: []
    )
  end
end
