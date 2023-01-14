Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users' }
  resources :users
  resources :divisions
  resources :completed_tasks, except: %w(show)

  namespace :admin do
    root 'panels#home'
    resources :positions,  
              :categories, 
              :departments, 
              :sub_categories, 
              :sub_departments, except: %w(show)
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  
  root to: "static_pages#home"
end
