class CustomersController < ApplicationController
  before_action :set_customer, only: [:show, :edit, :update, :destroy]

  def index
    authorize Customer
    scope = policy_scope(Customer).includes(:customer_vehicles)

    if params[:q].present?
      scope = scope.where("name ILIKE :q OR document ILIKE :q OR phone ILIKE :q OR mobile ILIKE :q",
                          q: "%#{params[:q]}%")
    end

    scope = scope.order(:name)
    @pagy, @customers = pagy(scope, limit: 25)
  end

  def show
    authorize @customer
    @sales = @customer.sales.confirmed.ordered.limit(10)
    @vehicles = @customer.customer_vehicles.includes(:vehicle_make, :vehicle_model)
  end

  def new
    @customer = current_company.customers.new
    authorize @customer
    load_form_data
  end

  def create
    @customer = current_company.customers.new(customer_params)
    authorize @customer

    if @customer.save
      redirect_to @customer, notice: "Cliente cadastrado com sucesso."
    else
      load_form_data
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @customer
    load_form_data
  end

  def update
    authorize @customer

    if @customer.update(customer_params)
      redirect_to @customer, notice: "Cliente atualizado com sucesso."
    else
      load_form_data
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @customer
    @customer.destroy
    redirect_to customers_path, notice: "Cliente removido."
  end

  private

  def set_customer
    @customer = policy_scope(Customer).find(params[:id])
  end

  def load_form_data
    @vehicle_makes = VehicleMake.active.ordered
  end

  def customer_params
    params.require(:customer).permit(
      :name, :document, :document_type, :phone, :mobile,
      :email, :address, :city, :state, :zip_code, :birthdate,
      :notes, :active,
      customer_vehicles_attributes: [
        :id, :vehicle_make_id, :vehicle_model_id,
        :year, :plate, :color, :chassis, :notes, :_destroy
      ]
    )
  end
end
