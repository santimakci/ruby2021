Rails.application.routes.draw do
  get 'exports/show'
  get 'exports/new'
  get 'exports/download'
  get 'home/create'
  get 'session/new'
  resources :professionals, only: [:new, :create, :destroy, :show, :edit, :update]
  resources :appointment, only: [:new, :create, :destroy, :update, :show, :edit] 
  resources :session, only: [:new, :create]
  resources :users, only: [:new, :create]
  root to: 'home#home'
  post 'close', to: 'session#close'
end
