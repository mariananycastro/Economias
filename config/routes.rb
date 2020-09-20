Rails.application.routes.draw do
  root to: "home#index"
  resource :categories, only: %i[new]
end
