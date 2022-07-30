Rails.application.routes.draw do
  root 'home#index'

  resources :users, param: :_username
  resources :blogs do
    resources :comments
  end
  
  post "/login", to: "authentication#login"
  
  get '/*a', to: 'application#not_found'
end
