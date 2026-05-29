class StockService
  def initialize(movement)
    @movement = movement
  end

  def process!
    ActiveRecord::Base.transaction do
      product = @movement.product

      @movement.previous_stock = product.stock_quantity

      quantity_change = case @movement.movement_type
      when "entry", "purchase", "return"
        @movement.quantity.abs
      when "exit", "sale_out"
        -@movement.quantity.abs
      when "adjustment"
        @movement.quantity
      else
        @movement.quantity
      end

      new_stock = product.stock_quantity + quantity_change
      raise "Estoque não pode ficar negativo" if new_stock < 0

      @movement.current_stock = new_stock
      @movement.save!

      product.update!(stock_quantity: new_stock)

      if @movement.movement_type == "purchase" && @movement.unit_cost.present?
        product.update!(cost_price: @movement.unit_cost)
      end

      true
    end
  rescue => e
    @movement.errors.add(:base, e.message)
    false
  end
end
