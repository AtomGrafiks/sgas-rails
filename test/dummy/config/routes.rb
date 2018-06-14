Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'application#home', auth: true
  get :login, to: 'application#login'

  resources :books, auth: true
end



# Rails.application.routes.routes.reject{ |a| a.name.nil? or a.name&.start_with?("rails_") }.last.defaults[:auth]