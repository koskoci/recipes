Rails.application.routes.draw do
  root to: "recipes#index"
  
  get "/search", to: "recipes#search"
end
