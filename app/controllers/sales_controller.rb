class SalesController < ApplicationController
  before_action :set_sale, only: [:show, :edit, :update, :destroy, :confirm, :cancel, :receipt]

  def index
    authorize Sale
    scope = policy_scope(Sale).includes(:customer, :user, :sale_items)

    scope = scope.where(status: params[:status]) if params[:status].present?
    scope = scope.where(sale_type: params[:sale_type]) if params[:sale_type].present?
    scope = scope.where(payment_method: params[:payment_method]) if params[:payment_method].present?

    if params[:start_date].present? && params[:end_date].present?
      scope = scope.where(created_at: params[:start_date].to_date.beginning_of_day..params[:end_date].to_date.end_of_day)
    end

    scope = scope.ordered
    @pagy, @sales = pagy(scope, limit: 25)
  end

  def show
    authorize @sale
  end

  def new
    @sale = current_company.sales.new(sale_type: params[:type] || "sale", status: "pending")
    @sale.customer_id = params[:customer_id] if params[:customer_id].present?
    authorize @sale
    load_form_data
  end

  def create
    @sale = current_company.sales.new(sale_params)
    @sale.user = current_user
    authorize @sale

    if @sale.save
      SaleService.new(@sale).process! if @sale.confirmed?
      redirect_to @sale, notice: "Venda criada com sucesso."
    else
      load_form_data
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @sale
    load_form_data
  end

  def update
    authorize @sale

    if @sale.update(sale_params)
      redirect_to @sale, notice: "Venda atualizada com sucesso."
    else
      load_form_data
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @sale
    @sale.destroy
    redirect_to sales_path, notice: "Venda removida."
  end

  def confirm
    authorize @sale
    if SaleService.new(@sale).confirm!
      redirect_to @sale, notice: "Venda confirmada com sucesso!"
    else
      redirect_to @sale, alert: "Não foi possível confirmar a venda."
    end
  end

  def cancel
    authorize @sale
    if @sale.cancel!(params[:reason])
      redirect_to @sale, notice: "Venda cancelada."
    else
      redirect_to @sale, alert: "Não foi possível cancelar a venda."
    end
  end

  def receipt
    authorize @sale
    respond_to do |format|
      format.html { render layout: "print" }
      format.pdf do
        pdf = SaleReceiptPdf.new(@sale)
        send_data pdf.render, filename: "pedido-#{@sale.number}.pdf",
                  type: "application/pdf", disposition: "inline"
      end
    end
  end

  private

  def set_sale
    @sale = policy_scope(Sale).find(params[:id])
  end

  def load_form_data
    @customers = policy_scope(Customer).active.ordered
    @products = policy_scope(Product).active.ordered
  end

  def sale_params
    params.require(:sale).permit(
      :customer_id, :sale_type, :payment_method,
      :discount_amount, :discount_percent, :notes, :status,
      sale_items_attributes: [:id, :product_id, :quantity, :unit_price, :discount_amount, :_destroy]
    )
  end
end
