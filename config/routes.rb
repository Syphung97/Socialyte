Rails.application.routes.draw do
  get 'password_resets/new'

  get 'password_resets/edit'

  get 'sessions/new'

  get "/login", to: "sessions#new"
  get "/logout", to: "sessions#destroy"
  post "/login", to: "sessions#create"
  get 'static_pages/home'
  root "static_pages#home"
  resources :users do
    member do
      resources :following, :follower
    end
  end

  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :microposts
  resources :relationships, only: [:create, :destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
