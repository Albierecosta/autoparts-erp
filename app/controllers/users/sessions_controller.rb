class Users::SessionsController < Devise::SessionsController
  def create
    super do |resource|
      unless resource.active?
        sign_out resource
        return redirect_to new_user_session_path, alert: "Sua conta está desativada."
      end
    end
  end
end
