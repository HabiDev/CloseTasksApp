require 'sidekiq/web'

Rails.application.routes.draw do
  
  mount Sidekiq::Web => '/sidekiq'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  # authenticated :user, ->(u) { u.admin? } do
  #   root to: "panels#home", as: :admin_root
  # end
  devise_for :users, controllers: { registrations: 'users' }
  resources :users do 
    collection do 
      get :fetch_department
    end
    patch "lock", on: :member, defaults: { format: :turbo_stream }
    patch "unlock", on: :member, defaults: { format: :turbo_stream }
  end
  resources :divisions
  resources :completed_tasks, except: %w(show)
  get :report_xls, action: :report_xls, controller: 'completed_tasks'
  get :report_tasks_xls, action: :report_tasks_xls, controller: 'tasks'
  resources :tasks do
    patch 'approval', on: :member, defaults: { format: :turbo_stream}
    patch 'rework', on: :member, defaults: { format: :turbo_stream }
    patch 'executed', on: :member, defaults: { format: :turbo_stream }
    patch 'delayed', on: :member, defaults: { format: :turbo_stream }  
    patch 'not_executed', on: :member, defaults: { format: :turbo_stream }
    patch 'canceled', on: :member, defaults: { format: :turbo_stream } 
    delete "destroy_photo", on: :member, defaults: { format: :turbo_stream } 
    post "create_photo", on: :member, defaults: { format: :turbo_stream }
    get "new_photo", on: :member
  end
  resources :missions do
    get 'approval', on: :member
    get 'rework', on: :member
    get 'executed', on: :member
    get 'delayed', on: :member
    get 'not_executed', on: :member
    get 'canceled', on: :member 
    post "create_deadline", on: :member
    get "new_deadline", on: :member 
    delete "destroy_app_file", on: :member, defaults: { format: :turbo_stream } 
    post "create_app_file", on: :member, defaults: { format: :turbo_stream }
    get "new_app_file", on: :member 
  end
  
  resources :related_missions, only: %w(new create destroy)

  resources :check_lists do
    patch 'check_status', on: :member, defaults: { format: :turbo_stream }    
  end
  resources :list_events, only: %w(edit update) do
    resources :list_event_tasks, only: %w(new create)
    patch 'update_status', on: :member, defaults: { format: :turbo_stream }
    post "create_photos", on: :member, defaults: { format: :turbo_stream }
    get "new_photos", on: :member
    delete "destroy_photos", on: :member, defaults: { format: :turbo_stream }
  end


  resources :mission_executors, except: %w(index show) do
    get 'rework', on: :member, defaults: { format: :turbo_stream }
    patch 'agree', on: :member, defaults: { format: :turbo_stream }
    patch 'canceled', on: :member, defaults: { format: :turbo_stream } 
    post "create_deadline", on: :member
    get "new_deadline", on: :member  
    delete "destroy_app_file", on: :member, defaults: { format: :turbo_stream } 
    post "create_app_file", on: :member, defaults: { format: :turbo_stream }
    get "new_app_file", on: :member
  end

  get :reports, action: :index, controller: 'reports'
  get :report_all_count, action: :report_all_count, controller: 'reports'


  resources :performed_works, except: %w(index show) do 
    delete "destroy_photo", on: :member, defaults: { format: :turbo_stream } 
    post "create_photo", on: :member, defaults: { format: :turbo_stream }
    get "new_photo", on: :member
  end
  # resources :mission_executors, except: %w(index show)
  resources :completed_missions, except: %w(index show)  do
    delete "destroy_app_file", on: :member, defaults: { format: :turbo_stream } 
    post "create_app_file", on: :member, defaults: { format: :turbo_stream }
    get "new_app_file", on: :member
  end

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
  get :report_check_list_xls, action: :report_check_list_xls, controller: 'check_lists'
  get 'edit_password_reset', to: 'users#edit_password_reset', as: :edit_password_reset
  patch 'password_reset', to: 'users#password_reset', as: :password_reset
  get 'executed_all', to: 'tasks#executed_all'
  get 'mission_calendar', to: 'missions#mission_calendar'
  root to: "static_pages#home"
end
