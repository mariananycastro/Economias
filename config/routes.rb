Rails.application.routes.draw do
  root to: "home#index"
  resources :categories, only: %i[new create edit update destroy]
  resources :account_types, only: %i[new create edit update destroy]
end
