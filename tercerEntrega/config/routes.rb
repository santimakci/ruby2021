Rails.application.routes.draw do
  get 'home/create'
  get 'session/new'
  resources :session, only: [:new, :create]
  resources :users, except: [:index, :edit]
  root to: 'home#home'
  post 'close', to: 'session#close'
end
