class SearchesController < ApplicationController
  def products
    authorize Product, :index?
    @products = if params[:q].present?
      policy_scope(Product).active.full_text_search(params[:q]).limit(10)
    else
      []
    end

    render json: @products.map { |p|
      {
        id: p.id,
        name: p.name,
        internal_code: p.internal_code,
        brand: p.brand,
        sale_price: p.sale_price,
        stock_quantity: p.stock_quantity
      }
    }
  end

  def customers
    authorize Customer, :index?
    @customers = if params[:q].present?
      policy_scope(Customer).active
        .where("name ILIKE :q OR document ILIKE :q OR phone ILIKE :q", q: "%#{params[:q]}%")
        .limit(10)
    else
      []
    end

    render json: @customers.map { |c|
      { id: c.id, name: c.name, document: c.document, phone: c.phone }
    }
  end

  def vehicle_models
    authorize VehicleMake, :index?
    @models = VehicleModel.where(vehicle_make_id: params[:make_id]).active.ordered
    render json: @models.map { |m| { id: m.id, name: m.name } }
  end
end
