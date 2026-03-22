Rails.application.routes.draw do
  resources :quotations, only: [:create]

  resources :shipments, only: [:create, :index, :show] do
    member do
      get :label
      get :tracking
    end
  end

  post "/webhooks/skydropx", to: "webhooks#skydropx"

  resource :session, only: [:create, :destroy]

  resources :stats, only: [] do
    collection do
      get :carriers
    end
  end
end
