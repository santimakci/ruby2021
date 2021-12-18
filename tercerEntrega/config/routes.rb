Rails.application.routes.draw do
  get 'home/create'
  get 'session/new'
  get 'appointment/export'
  post 'appointment/create_export'
  resources :professionals, only: [:new, :create, :destroy, :show, :edit, :update]
  resources :appointment, only: [:new, :create, :destroy, :update, :show, :edit] 
  resources :session, only: [:new, :create]
  resources :users, only: [:new, :create]
  root to: 'home#home'
  post 'close', to: 'session#close'
end
