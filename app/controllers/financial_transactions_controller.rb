class FinancialTransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :edit, :update, :destroy, :pay]

  def index
    authorize FinancialTransaction
    scope = policy_scope(FinancialTransaction).includes(:customer, :supplier, :sale)

    scope = scope.where(transaction_type: params[:type]) if params[:type].present?
    scope = scope.where(status: params[:status]) if params[:status].present?

    if params[:start_date].present? && params[:end_date].present?
      scope = scope.where(due_date: params[:start_date].to_date..params[:end_date].to_date)
    end

    scope = scope.ordered
    @pagy, @transactions = pagy(scope, limit: 25)

    @total_income = policy_scope(FinancialTransaction).income.paid.this_month.sum(:amount)
    @total_expense = policy_scope(FinancialTransaction).expense.paid.this_month.sum(:amount)
    @balance = @total_income - @total_expense
  end

  def show
    authorize @transaction
  end

  def new
    @transaction = current_company.financial_transactions.new(
      transaction_type: params[:type] || "income",
      due_date: Date.current
    )
    authorize @transaction
    load_form_data
  end

  def create
    @transaction = current_company.financial_transactions.new(transaction_params)
    @transaction.user = current_user
    authorize @transaction

    if @transaction.save
      redirect_to financial_transactions_path, notice: "Lançamento criado com sucesso."
    else
      load_form_data
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @transaction
    load_form_data
  end

  def update
    authorize @transaction

    if @transaction.update(transaction_params)
      redirect_to financial_transactions_path, notice: "Lançamento atualizado com sucesso."
    else
      load_form_data
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @transaction
    @transaction.destroy
    redirect_to financial_transactions_path, notice: "Lançamento removido."
  end

  def pay
    authorize @transaction
    if @transaction.mark_as_paid!(params[:paid_at]&.to_date)
      redirect_to financial_transactions_path, notice: "Lançamento marcado como pago."
    else
      redirect_to @transaction, alert: "Não foi possível realizar a baixa."
    end
  end

  private

  def set_transaction
    @transaction = policy_scope(FinancialTransaction).find(params[:id])
  end

  def load_form_data
    @customers = policy_scope(Customer).active.ordered
    @suppliers = policy_scope(Supplier).active.ordered
  end

  def transaction_params
    params.require(:financial_transaction).permit(
      :transaction_type, :category, :description, :amount,
      :payment_method, :status, :due_date, :paid_at,
      :reference_number, :notes, :customer_id, :supplier_id
    )
  end
end
