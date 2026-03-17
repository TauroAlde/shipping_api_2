Rails.application.routes.draw do
  resources :quotations, only: [:create]

  resources :shipments, only: [:create, :index, :show]

  post "/webhooks/skydropx", to: "webhooks#skydropx"

  resources :shipments, only: [:create, :index, :show] do
    member do
      get :label
    end

    member do
      get :tracking
    end
  end

  resource :session, only: [:create, :destroy]
end
