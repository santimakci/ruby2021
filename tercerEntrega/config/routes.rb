Rails.application.routes.draw do
  get 'home/create'
  get 'session/new'
  resources :professionals, only: [:new, :create, :destroy]
  resources :appointment, only: [:new, :create, :destroy, :update]
  resources :session, only: [:new, :create]
  resources :users, only: [:new, :create]
  root to: 'home#home'
  post 'close', to: 'session#close'
end
