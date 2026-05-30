class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  stale_when_importmap_changes

  include Pundit::Authorization
  include Pagy::Backend

  before_action :set_locale
  before_action :authenticate_user!
  before_action :set_current_company
  before_action :check_company_active

  after_action :verify_authorized, if: -> { !devise_controller? && action_name != "index" }
  after_action :verify_policy_scoped, if: -> { !devise_controller? && action_name == "index" }

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def set_locale
    I18n.locale = :"pt-BR"
  end

  def set_current_company
    @current_company = current_user&.company
  end

  def current_company
    @current_company
  end
  helper_method :current_company

  def check_company_active
    return unless @current_company
    redirect_to root_path, alert: "Empresa inativa." unless @current_company.active?
  end

  def user_not_authorized
    flash[:alert] = "Você não tem permissão para realizar esta ação."
    redirect_back(fallback_location: root_path)
  end
end
