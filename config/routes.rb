Rails.application.routes.draw do
  resources :wish_items
  resources :wishlists
  
  resources :orders

  # routing devise to use our custom registrations controller
  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks', sessions: 'sessions', registrations: 'registrations'}

  devise_scope :user do
    delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_omniauth_user_session
  end

  resources :users, only: [:show, :edit, :update]
  
  resources :users_admin, :controller => 'users'
  
  resources :items do
    resources :reviews, except: [:show, :index]
    resources :subscribes, except: [:show, :index]
  end

  resources :payment, :only => [:index, :show, :create]
  get :send_otp, to: 'payment#send_otp', as: :send_otp
  post :verify_otp, to: 'payment#verify_otp', as: :verify_otp

  get 'payment/index'
  resources :line_items
  resources :carts

  # updating the table
  post 'orders/:id/update_status' => 'orders#update_status', :as => :orders_update_status

  # Routing to HomePage
  root 'welcome#index'
end
