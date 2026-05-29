class SuppliersController < ApplicationController
  before_action :set_supplier, only: [:show, :edit, :update, :destroy]

  def index
    authorize Supplier
    scope = policy_scope(Supplier)
    scope = scope.where("name ILIKE ?", "%#{params[:q]}%") if params[:q].present?
    scope = scope.order(:name)
    @pagy, @suppliers = pagy(scope, limit: 25)
  end

  def show
    authorize @supplier
  end

  def new
    @supplier = current_company.suppliers.new
    authorize @supplier
  end

  def create
    @supplier = current_company.suppliers.new(supplier_params)
    authorize @supplier

    if @supplier.save
      redirect_to @supplier, notice: "Fornecedor cadastrado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @supplier
  end

  def update
    authorize @supplier

    if @supplier.update(supplier_params)
      redirect_to @supplier, notice: "Fornecedor atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @supplier
    @supplier.destroy
    redirect_to suppliers_path, notice: "Fornecedor removido."
  end

  private

  def set_supplier
    @supplier = policy_scope(Supplier).find(params[:id])
  end

  def supplier_params
    params.require(:supplier).permit(
      :name, :trade_name, :cnpj, :phone, :email,
      :contact_name, :address, :city, :state, :zip_code, :notes, :active
    )
  end
end
