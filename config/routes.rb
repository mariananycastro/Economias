Rails.application.routes.draw do
  root to: "home#index"
  resources :categories, only: %i[new create edit update destroy]
end
