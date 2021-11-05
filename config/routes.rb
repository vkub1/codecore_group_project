Rails.application.routes.draw do
  get 'facilities/index'
  get 'facilities/show'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get('/', {to: 'welcome#index', as: 'root'})


  get('/admin', {to: 'users#admin',as: 'admin'})



 
  resources :users, only: [:new, :create] do
    resources :notifications, only: [:index, :update]
    resources :enrollments, only: [:index, :create, :update, :destroy]
    
  end
  resources :courses do
    resources :bookings, only: [:index, :create,:edit, :update, :destroy , :new]
  end

  resources :facilities
  
  resource :session, only: [:new, :create, :destroy]

  get('/booked_facilities', {to: "bookings#index", as: 'booked_facilities'})



end
