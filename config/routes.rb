Rails.application.routes.draw do
  get 'users/sign_up', as: 'sign_up'
  get 'users/log_in', as: 'log_in'

  get 'home/index'
  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
