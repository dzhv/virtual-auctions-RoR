Rails.application.routes.draw do
  get 'login/show', as: 'log_in'

  post 'login/log_in', as: 'sign_in'

  resources :users
  get 'home/index'
  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
