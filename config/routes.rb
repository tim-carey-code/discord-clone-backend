Rails.application.routes.draw do
  devise_for :users
  post 'users/register', to: 'users#register'
  post 'users/login', to: 'users#login' 
  resources :chatrooms do
    resources :messages
  end
end
