class VehicleApplicationsController < ApplicationController
  before_action :set_product

  def create
    authorize @product, :update?
    @application = @product.vehicle_applications.new(application_params)
    @application.vehicle_make = VehicleMake.find(params[:vehicle_application][:vehicle_make_id])
    @application.vehicle_model = VehicleModel.find(params[:vehicle_application][:vehicle_model_id])

    if @application.save
      redirect_to @product, notice: "Compatibilidade adicionada."
    else
      redirect_to @product, alert: "Erro ao adicionar compatibilidade."
    end
  end

  def destroy
    authorize @product, :update?
    @product.vehicle_applications.find(params[:id]).destroy
    redirect_to @product, notice: "Compatibilidade removida."
  end

  private

  def set_product
    @product = policy_scope(Product).find(params[:product_id])
  end

  def application_params
    params.require(:vehicle_application).permit(:vehicle_make_id, :vehicle_model_id, :year_from, :year_to, :engine, :version, :notes)
  end
end
