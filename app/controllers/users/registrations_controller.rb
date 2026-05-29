class Users::RegistrationsController < Devise::RegistrationsController
  before_action :redirect_to_login

  private

  def redirect_to_login
    redirect_to new_user_session_path, alert: "Registro público desativado. Contate o administrador."
  end
end
