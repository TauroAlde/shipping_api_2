Rails.application.routes.draw do
  post "/quotations", to: "quotations#create"
end
