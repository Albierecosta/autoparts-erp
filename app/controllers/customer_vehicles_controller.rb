class CustomerVehiclesController < ApplicationController
  before_action :set_customer

  def create
    authorize @customer, :update?
    @vehicle = @customer.customer_vehicles.new(vehicle_params)

    if @vehicle.save
      redirect_to @customer, notice: "Veículo adicionado."
    else
      redirect_to @customer, alert: "Erro ao adicionar veículo."
    end
  end

  def destroy
    authorize @customer, :update?
    @customer.customer_vehicles.find(params[:id]).destroy
    redirect_to @customer, notice: "Veículo removido."
  end

  private

  def set_customer
    @customer = policy_scope(Customer).find(params[:customer_id])
  end

  def vehicle_params
    params.require(:customer_vehicle).permit(:vehicle_make_id, :vehicle_model_id, :year, :plate, :color, :chassis, :notes)
  end
end
