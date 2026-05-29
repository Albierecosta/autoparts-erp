Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  root "dashboard#index"

  get "up" => "rails/health#show", as: :rails_health_check
  get "ping" => proc { [200, {}, ["ok"]] }, as: :ping

  resources :products do
    resources :stock_movements, only: [:index, :new, :create], shallow: true
    resources :vehicle_applications, only: [:create, :destroy]
  end

  resources :categories
  resources :suppliers
  resources :customers do
    resources :customer_vehicles, only: [:create, :destroy], shallow: true
    get :sales, on: :member
  end

  resources :sales do
    member do
      patch :confirm
      patch :cancel
      get :receipt
    end
  end

  resources :stock_movements, only: [:index, :new, :create]

  resources :financial_transactions do
    member do
      patch :pay
    end
  end

  resources :users

  scope "/search", as: "search" do
    get "products",      to: "searches#products",      as: :products
    get "customers",     to: "searches#customers",     as: :customers
    get "vehicle_models", to: "searches#vehicle_models", as: :vehicle_models
  end

  namespace :reports do
    get :sales
    get :stock
    get :financial
    get :customers
  end

  namespace :settings do
    resource :company, only: [:show, :edit, :update]
    resource :ecommerce, only: [:show, :edit, :update]
  end

  require "sidekiq/web"
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end
end
