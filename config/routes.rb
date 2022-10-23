Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users' }
  resources :users
  resources :divisions
  resources :completed_tasks, except: %w(show)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  
  root to: "static_pages#home"
end
