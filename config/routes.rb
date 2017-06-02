Rails.application.routes.draw do
  devise_for :users, :controllers => {registrations: 'registrations'}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users do
    collection do
      get 'search'
    end
    member do
      post 'leave_group'
    end
  end

  resources :groups do
    resources :tasks, only: [:new, :create, :edit, :update, :destroy]

    collection do
      get 'search'
    end

    member do
      post 'request_join'
      post 'add_member'
    end
  end

  authenticated :user do
    root 'users#dashboard', as: :user_dashboard
  end

  root 'static_pages#home'
end
