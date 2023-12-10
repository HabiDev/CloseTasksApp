Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  # authenticated :user, ->(u) { u.admin? } do
  #   root to: "panels#home", as: :admin_root
  # end
  devise_for :users, controllers: { registrations: 'users' }
  resources :users
  resources :divisions
  resources :completed_tasks, except: %w(show)
  get :report_xls, action: :report_xls, controller: 'completed_tasks'
  get :report_tasks_xls, action: :report_tasks_xls, controller: 'tasks'
  resources :tasks do
    patch 'approval', on: :member, defaults: { format: :turbo_stream }
    patch 'rework', on: :member, defaults: { format: :turbo_stream }
    patch 'executed', on: :member, defaults: { format: :turbo_stream }
    patch 'delayed', on: :member, defaults: { format: :turbo_stream }  
    patch 'not_executed', on: :member, defaults: { format: :turbo_stream }
    patch 'canceled', on: :member, defaults: { format: :turbo_stream } 
  end
  resources :missions do
    patch 'approval', on: :member, defaults: { format: :turbo_stream }
    patch 'rework', on: :member, defaults: { format: :turbo_stream }
    patch 'executed', on: :member, defaults: { format: :turbo_stream }
    patch 'delayed', on: :member, defaults: { format: :turbo_stream }  
    patch 'not_executed', on: :member, defaults: { format: :turbo_stream }
    patch 'canceled', on: :member, defaults: { format: :turbo_stream } 
  end

  resources :check_lists do
    patch 'check_status', on: :member, defaults: { format: :turbo_stream }
  end
  resources :list_events, only: %w(edit update) do
    resources :list_event_tasks, only: %w(new create)
    patch 'update_status', on: :member, defaults: { format: :turbo_stream }
  end


  resources :mission_executors, except: %w(index show) do
    get 'rework', on: :member, defaults: { format: :turbo_stream }
    patch 'agree', on: :member, defaults: { format: :turbo_stream }
    patch 'canceled', on: :member, defaults: { format: :turbo_stream } 
  end

  get :reports, action: :index, controller: 'reports'
  get :report_all_count, action: :report_all_count, controller: 'reports'


  resources :performed_works, except: %w(index show)
  # resources :mission_executors, except: %w(index show)
  resources :completed_missions, except: %w(index show)  

  namespace :admin do
    root 'panels#home'
    resources :positions,  
              :categories, 
              :departments, 
              :sub_categories, 
              :sub_departments, 
              :mission_types,
              :check_list_types,
              :check_list_groups,
              :sub_check_lists,
              :priorities, except: %w(show)
  end
  get 'edit_password_reset', to: 'users#edit_password_reset', as: :edit_password_reset
  patch 'password_reset', to: 'users#password_reset', as: :password_reset

  root to: "static_pages#home"
end
