Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users' }
  resources :users
  resources :divisions
  resources :completed_tasks, except: %w(show)
  resources :tasks do
    patch 'approval', on: :member, defaults: { format: :turbo_stream }
    patch 'rework', on: :member, defaults: { format: :turbo_stream }
    patch 'executed', on: :member, defaults: { format: :turbo_stream }
    patch 'delayed', on: :member, defaults: { format: :turbo_stream }  
    patch 'not_executed', on: :member, defaults: { format: :turbo_stream }
    patch 'canceled', on: :member, defaults: { format: :turbo_stream } 
  end
  resources :performed_works, except: %w(index show)
  

  namespace :admin do
    root 'panels#home'
    resources :positions,  
              :categories, 
              :departments, 
              :sub_categories, 
              :sub_departments, 
              :priorities, except: %w(show)
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  # authenticated :user, ->(u) { u.admin? } do
  #   root to: "panels#home", as: :admin_root
  # end

  root to: "static_pages#home"
end
