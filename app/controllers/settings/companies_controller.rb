module Settings
  class CompaniesController < ApplicationController
    before_action :require_admin!

    def show
      @company = current_company
      authorize @company, :show?, policy_class: Settings::CompanyPolicy
    end

    def edit
      @company = current_company
      authorize @company, :edit?, policy_class: Settings::CompanyPolicy
    end

    def update
      @company = current_company
      authorize @company, :update?, policy_class: Settings::CompanyPolicy

      if @company.update(company_params)
        redirect_to settings_company_path, notice: "Configurações atualizadas."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def require_admin!
      redirect_to root_path, alert: "Acesso restrito." unless current_user.admin?
    end

    def company_params
      params.require(:company).permit(
        :name, :trade_name, :cnpj, :phone, :email,
        :address, :city, :state, :zip_code, :logo,
        :ecommerce_enabled,
        settings: [:receipt_footer, :currency_symbol, :default_payment_method, :low_stock_alert_enabled]
      )
    end
  end
end
