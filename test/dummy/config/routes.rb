Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # root to: 'application#home', auth: true
  get :login, to: 'application#login'
  get :home, to: 'application#home', auth: true

  resources :books, auth: true
end