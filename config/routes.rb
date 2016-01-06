Rails.application.routes.draw do
  devise_for :users
  resources :users,:events
  root to: 'events#index'
  
end
