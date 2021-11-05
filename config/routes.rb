Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get('/', {to: "welcome#index", as: 'root'})
  resources :users, only: [:new, :create] do
    resources :notifications, only: [:index, :destroy]
    resources :enrollments, only: [:index, :create, :update, :destroy]
    
  end
  resources :courses do
    resources :bookings, only: [:index, :create, :update, :destroy, :new]
  end

  resources :facilities
  
  resource :session, only: [:new, :create, :destroy]
#  get('/admin', {to: "user#admin", as 'admin'})


##get('/booking/index', {to:"booking#index"})
##get('/booking/new', {to:"booking#new"})
end