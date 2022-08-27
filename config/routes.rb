Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  resources :books
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'books#index'
end
