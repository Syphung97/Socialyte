Rails.application.routes.draw do
  get 'sessions/new'

  get "/login", to: "sessions#new"
  get "/logout", to: "sessions#destroy"
  post "/login", to: "sessions#create"
  get 'static_pages/home'
  root "static_pages#home"
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
