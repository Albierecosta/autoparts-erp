class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    authorize User
    scope = policy_scope(User).ordered_by_name
    @pagy, @users = pagy(scope, limit: 25)
  end

  def show
    authorize @user
  end

  def new
    @user = current_company.users.new
    authorize @user
  end

  def create
    @user = current_company.users.new(user_params)
    authorize @user

    if @user.save
      redirect_to users_path, notice: "Usuário criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @user
  end

  def update
    authorize @user

    if @user.update(user_params_for_update)
      redirect_to users_path, notice: "Usuário atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @user

    if @user == current_user
      redirect_to users_path, alert: "Você não pode remover seu próprio usuário."
    else
      @user.destroy
      redirect_to users_path, notice: "Usuário removido."
    end
  end

  private

  def set_user
    @user = policy_scope(User).find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role, :active)
  end

  def user_params_for_update
    permitted = params.require(:user).permit(:name, :email, :role, :active, :password, :password_confirmation)
    permitted.reject! { |k, v| k.in?(["password", "password_confirmation"]) && v.blank? }
    permitted
  end
end
