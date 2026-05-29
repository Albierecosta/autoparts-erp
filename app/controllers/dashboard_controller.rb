class DashboardController < ApplicationController
  def index
    authorize :dashboard, :index?

    @today_sales = policy_scope(Sale).confirmed.today
    @today_revenue = @today_sales.sum(:total)
    @today_sales_count = @today_sales.count

    @month_revenue = policy_scope(Sale).confirmed.this_month.sum(:total)

    @low_stock_products = policy_scope(Product).active.low_stock.limit(10)
    @recent_sales = policy_scope(Sale).confirmed.ordered.limit(8)

    @pending_receivables = policy_scope(FinancialTransaction).income.pending.sum(:amount)
    @pending_payables = policy_scope(FinancialTransaction).expense.pending.sum(:amount)

    @cash_flow_data = build_cash_flow_data
  end

  private

  def build_cash_flow_data
    7.downto(0).map do |days_ago|
      date = days_ago.days.ago.to_date
      sales = policy_scope(Sale).confirmed
                                .where(created_at: date.all_day)
                                .sum(:total)
      expenses = policy_scope(FinancialTransaction).expense.paid
                                                   .where(paid_at: date)
                                                   .sum(:amount)
      { date: date, revenue: sales, expenses: expenses }
    end
  end
end
