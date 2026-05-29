class SaleService
  def initialize(sale)
    @sale = sale
  end

  def confirm!
    ActiveRecord::Base.transaction do
      @sale.confirm!
      deduct_stock!
      create_financial_transaction!
    end
    true
  rescue => e
    @sale.errors.add(:base, e.message)
    false
  end

  def process!
    confirm! if @sale.confirmed?
  end

  private

  def deduct_stock!
    @sale.sale_items.each do |item|
      product = item.product
      movement = StockMovement.new(
        company: @sale.company,
        product: product,
        user: @sale.user,
        sale: @sale,
        movement_type: "sale_out",
        quantity: -item.quantity,
        previous_stock: product.stock_quantity,
        current_stock: product.stock_quantity - item.quantity,
        reason: "Venda ##{@sale.number}"
      )

      raise "Estoque insuficiente para #{product.name}" if product.stock_quantity < item.quantity

      product.decrement!(:stock_quantity, item.quantity)
      movement.save!
    end
  end

  def create_financial_transaction!
    return if @sale.total.to_f.zero?
    FinancialTransaction.create!(
      company: @sale.company,
      user: @sale.user,
      sale: @sale,
      customer: @sale.customer,
      transaction_type: "income",
      category: "sale",
      description: "Venda ##{@sale.number}",
      amount: @sale.total,
      payment_method: @sale.payment_method,
      status: @sale.payment_method.present? ? "paid" : "pending",
      paid_at: Date.current,
      due_date: Date.current
    )
  end
end
