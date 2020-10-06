Rails.application.routes.draw do
  root to: "home#index"
  resources :categories, only: %i[new create edit update destroy]
  resources :account_types, only: %i[new create edit update destroy]
  resources :accounts, only: %i[new create edit update destroy]
  resources :transactions, only: %i[new create edit update destroy]
  resources :transfers, only: %i[new create edit update destroy]
end
