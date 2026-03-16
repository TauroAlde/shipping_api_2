Rails.application.routes.draw do
  post "/quotations", to: "quotations#create"
  post "/shipments", to: "shipments#create"
  post "/webhooks/skydropx", to: "webhooks#skydropx"
end
